import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sagem/colories.dart';

import '../../models/ligne.dart';
import '../../models/magasin.dart';
import '../../models/picklistadd.dart';
import '../Magasin/magasin_controller.dart';
import 'api_handler.dart';

class AddPickList extends StatefulWidget {
  const AddPickList({super.key});

  @override
  AddPickListState createState() => AddPickListState();
}

class AddPickListState extends State<AddPickList> {
  final TextEditingController numeroLigneController = TextEditingController();
  late List<Magasin> magasins;
  Magasin? selectedMagasin;
  late List<Ligne> lignes;
  int? selectedLine;

  @override
  void initState() {
    super.initState();
    magasins = [];
    lignes = [];
    fetchMagasins();
    fetchLignes();
  }

  void fetchMagasins() async {
    final controller = MagasinController();
    final fetchedMagasins = await controller.getMagasins();
    setState(() {
      magasins = fetchedMagasins;
    });
  }

  void fetchLignes() async {
    final ApiHandler apiHandler = ApiHandler();
    try {
      final List<Ligne> fetchedLignes = await apiHandler.getLigne();
      setState(() {
        lignes = fetchedLignes;
      });
    } catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Fail',
          message: "Failed to fetch lines",
          contentType: ContentType.failure,
        ),
      );
      
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  void addPickList() async {
    final DateTime dateNow = DateTime.now();
    final picklist = PickListadd(
      date: DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(dateNow.toUtc()),
    );

    final ApiHandler apiHandler = ApiHandler();
    final responseidM = selectedMagasin!;
    final responseidL = await apiHandler.getLigneByNum(selectedLine!);
    int idSt = 1;

    final response = await apiHandler.addPickList(
      picklist: picklist,
      idMg: responseidM.idMg,
      idLigne: responseidL.idLigne,
      idSt: idSt,
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success',
          message: 'PickList added successfully',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      Navigator.pop(context);
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: 'PickList Added',
          body: 'A new picklist has been successfully added.',
          notificationLayout: NotificationLayout.Default,
        ),
      );
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Fail',
          message: 'Failed to add PickList',
          contentType: ContentType.failure,
        ),
      );
      
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Add PickList"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        body: Stack(
          children: [
            const Colorie(),
            Container(),
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Form(
                child: Column(
                  children: [
                    DropdownButtonFormField<Magasin>(
                      value: selectedMagasin,
                      onChanged: (value) {
                        setState(() {
                          selectedMagasin = value;
                        });
                      },
                      items: magasins.map((magasin) {
                        return DropdownMenuItem<Magasin>(
                          value: magasin,
                          child: Text(magasin.nomMg),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Nom Magasin',
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                      value: selectedLine,
                      onChanged: (value) {
                        setState(() {
                          selectedLine = value;
                        });
                      },
                      items: lignes.map((ligne) {
                        return DropdownMenuItem<int>(
                          value: ligne.numLigne,
                          child: Text('Ligne ${ligne.numLigne}'),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Numero Ligne',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: addPickList,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF17203A),
                      )),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}
