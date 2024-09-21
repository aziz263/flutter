import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sagem/colories.dart';

import '../../models/magasinadd.dart';
import '../../screens/Magasin/magasin_controller.dart';

class AddMagasin extends StatefulWidget {
  const AddMagasin({super.key});

  @override
  AddMagasinState createState() => AddMagasinState();
}

class AddMagasinState extends State<AddMagasin> {
  final TextEditingController _nomMagasinController = TextEditingController();

  Future<void> _addMagasin() async {
    final String nomMagasin = _nomMagasinController.text.trim();
    if (nomMagasin.isNotEmpty) {
      final newMagasin = MagasinAdd(
        nomMg: nomMagasin,
      );
      try {
        final MagasinController controller = MagasinController();
        final http.Response response =
            await controller.addMagasin(magasin: newMagasin);
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          // showSnackbar(
          //   context,
          //   message: 'Magsain ajouté avec succès',
          //   duration: const Duration(seconds: 2),
          // );
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success',
              message: "Magsain ajouté avec succès",
              contentType: ContentType.success,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          Navigator.pop(context, true);
        } else {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Fail',
              message: "Failed to add magasin: ${response.statusCode}",
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      } catch (e) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Fail',
            message: "Failed to add magasin: $e",
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Add Magasin"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(children: [
        const Colorie(),
        Padding(
          padding: const EdgeInsets.only(top: 120.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nomMagasinController,
                decoration: const InputDecoration(labelText: 'Nom Magasin'),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  child: Center(
                child: ElevatedButton(
                    onPressed: _addMagasin,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF17203A),
                      ),
                    ),
                    child: const Text('Add Magasin')),
              )),
            ],
          ),
        ),
      ]),
    );
  }
}
