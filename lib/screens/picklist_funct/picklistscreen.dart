import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import 'package:sagem/constants.dart';
import 'package:sagem/models/ligne.dart';
import 'package:sagem/models/magasin.dart';
import 'package:sagem/models/magasinier.dart';
import 'package:sagem/screens/Magasinier_funct/magasinier_controller.dart';
import 'package:sagem/screens/picklist_funct/api_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Design/picklist_table.dart';
import '../../colories.dart';
import '../../models/detailpicklist.dart';
import '../../models/picklist.dart';
import '../Magasin/magasin_controller.dart';
import '../detailpicklist_funct/detailpicklistscreen.dart';
import 'picklistcreate.dart';

class PicklistPage extends StatefulWidget {
  const PicklistPage({super.key});

  @override
  PicklistPageState createState() => PicklistPageState();
}

class PicklistPageState extends State<PicklistPage> {
  late List<PickList> data = [];
  late ApiHandler apiHandler = ApiHandler();
  late List<Magasin> magasins = [];
  late List<Ligne> lignes = [];
  late List<String> magasinOptions = [];
  late List<String> ligneOptions = [];
  List<dynamic> selectedMagasin = []; 
  List<dynamic> selectedLignes = []; 
  @override
  void initState() {
    super.initState();
    fetchPicklists();
    fetchLignes();
    fetchMagasins();
  }

  Future<void> fetchPicklists() async {
    try {
      final response = await http.get(
        Uri.parse('$url/api/PickList/CodeSt?CodeSt=demand%C3%A9'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        List<dynamic> jsondata = jsonDecode(response.body);

        setState(() {
          data = jsondata.map((item) => PickList.fromJson(item)).toList();
        });
        checkAndCreateNotifications();
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Text('Fail'),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  void checkAndCreateNotifications() {
    SharedPreferences.getInstance().then((prefs) async {
      final String? lastPicklistId = prefs.getString('lastPicklistId');

      if (lastPicklistId != null) {
        final int lastId = int.parse(lastPicklistId);
        final List<PickList> newPicklists =
            data.where((picklist) => picklist.idPickList > lastId).toList();

        if (newPicklists.isNotEmpty) {
          createNotifications(newPicklists);
        }
      }
      prefs.setString('lastPicklistId', data.last.idPickList.toString());
    });
  }

  void createNotifications(List<PickList> picklists) {
    for (var picklist in picklists) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: picklist.idPickList,
          channelKey: "basic_channel",
          title: "New Picklist",
          body: "Picklist ID: ${picklist.idPickList}",
        ),
      );
    }
  }

  Future<void> viewDetailPicklists(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$url/api/DetailPickList/Id_PickList?id=$id'),
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        final List<dynamic> detailPicklistsData = jsonDecode(response.body);
        if (detailPicklistsData.isEmpty) {
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPicklistScreen(
                id: id,
                detailPicklists: detailPicklistsData,
              ),
            ),
          );
        }
      } else {}
    } catch (e) {
      log('Error fetching detail picklists: $e');
    }
  }

  void fetchMagasins() async {
    final controller = MagasinController();
    final fetchedMagasins = await controller.getMagasins();
    setState(() {
      magasins = fetchedMagasins;
      magasinOptions = magasins.map((magasin) => magasin.nomMg).toList();
    });
  }

  void fetchLignes() async {
    final ApiHandler apiHandler = ApiHandler();
    try {
      final List<Ligne> fetchedLignes = await apiHandler.getLigne();
      setState(() {
        lignes = fetchedLignes;
        ligneOptions =
            lignes.map((ligne) => ligne.numLigne.toString()).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch lines'),
            duration: Duration(seconds: 2),
          ),
        );
    }
  }

  // Future<void> fetchPicklistsByMagasin(String nom) async {
  //   try {
  //     List<PickList> newData = await apiHandler.fetchPicklistsByMagasin(nom);
  //     setState(() {
  //       newData = newData
  //           .where((newPicklist) => !data.contains(newPicklist))
  //           .toList();
  //       data.addAll(newData);
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //       ..hideCurrentSnackBar()
  //       ..showSnackBar(
  //         const SnackBar(
  //           content: Text('Error fetching picklists by magasin'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //   }
  // }

  // Future<void> fetchPicklistsByNumLigne(String numLigne) async {
  //   try {
  //     List<PickList> newData =
  //         await apiHandler.fetchPicklistsByNumLigne(numLigne);
          
  //     setState(() {
  //       newData = newData
  //           .where((newPicklist) => !data.contains(newPicklist))
  //           .toList();
  //       data.addAll(newData);
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //       ..hideCurrentSnackBar()
  //       ..showSnackBar(
  //         const SnackBar(
  //           content: Text('Error fetching picklists by num ligne'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //   }
  // }
  void applyFilters(){
    setState(() {
      data = data.where((picklist){
        bool matchesMagasin = selectedMagasin.isEmpty ||
        selectedMagasin.contains(picklist.nomMagasin);
        bool matchesLigne = selectedLignes.isEmpty ||
        selectedLignes.contains(picklist.numLigne.toString());
        return matchesMagasin && matchesLigne;
      }).toList();
    });
  }


  Future<void> updatePicklistStatue(int id) async {
    final response = await http.get(
      Uri.parse('$url/api/DetailPickList/Id_PickList?id=$id'),
    );
    if (response.statusCode >= 200 && response.statusCode <= 399) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<DetailPicklist> detailPicklists =
          jsonData.map((json) => DetailPicklist.fromJson(json)).toList();
      if (detailPicklists
          .every((detailPicklist) => detailPicklist.codeSt == "servie")) {
        await http.put(
          Uri.parse("$url/api/PickList/Id_PickList?PickListId=$id"),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: json.encode({'idSt': 2}),
        );
      }
    }
  }

  Future<void> refreshData() async {
    await fetchPicklists();
    for (var picklist in data) {
      await updatePicklistStatue(picklist.idPickList);
    }
  }
  void handleSelectionChange() {
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Picklists'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            color: const Color.fromARGB(221, 213, 213, 213),
            icon: const Icon(Icons.filter_list),
            onSelected: (String result) {
              setState(() {
                switch (result) {
                  case 'Magasins':
                    fetchMagasins();
                    break;
                  case 'Lignes':
                    fetchLignes();
                    break;
                  default:
                    fetchPicklists();
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Magasins',
                child: SizedBox(
                  height: 70,
                  width: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MultiSelectDropdown.simpleList(
                          whenEmpty: 'Magasins',
                          checkboxFillColor:
                              const Color.fromARGB(221, 213, 213, 213),
                          splashColor: Colors.blue,
                          width: 200,
                          list: magasinOptions,
                          initiallySelected: const [],
                          onChange: (newList) {
                            if (newList.isNotEmpty) {
                                selectedMagasin = newList;
                                handleSelectionChange();
                            }
                          },
                          includeSearch: false,
                          includeSelectAll: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'Lignes',
                child: SizedBox(
                  height: 70,
                  width: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MultiSelectDropdown.simpleList(
                          whenEmpty: 'Lignes',
                          checkboxFillColor:
                              const Color.fromARGB(233, 213, 213, 213),
                          splashColor: Colors.blue,
                          width: 200,
                          list: ligneOptions,
                          initiallySelected: const [],
                          onChange: (newList) {
                            selectedLignes = newList;
                            handleSelectionChange();
                          },
                          includeSearch: false,
                          includeSelectAll: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? mail = prefs.getString('mail');

          final controller = MagasinierController();
          final Magasinier magasinier =
              await controller.getMagasinierBymail(mail);
          if (magasinier.adminRole == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPickList()),
            );
          } else {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Warning',
                message: 'Only admins can access this',
                contentType: ContentType.warning,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
        },
        backgroundColor: const Color(0xFF17203A),
        child: const Icon(
          Icons.add_business,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          const Colorie(),
          RefreshIndicator(
            onRefresh: refreshData,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var picklist = data[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: PicklistTable(
                    title: "Picklist : ${picklist.idPickList}",
                    magasin: picklist.nomMagasin,
                    ligne: picklist.numLigne,
                    date: DateFormat('yyyy-MM-dd').format(picklist.date),
                    colorl: const Color.fromARGB(97, 248, 62, 81),
                    onPressed: () {
                      viewDetailPicklists(picklist.idPickList);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
