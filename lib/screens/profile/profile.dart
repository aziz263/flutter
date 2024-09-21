import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sagem/colories.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../models/magasinier.dart';
import '../../models/magasinier_update.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late Magasinier magasinier;

  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final mailController = TextEditingController();
  final ageController = TextEditingController();
  final idController = TextEditingController();

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      String? mail = prefs.getString('mail');
      magasinier = fetchMagasinierBymail(mail) as Magasinier;
    });
    super.initState();
  }
   @override
  void dispose() {
    nomController.dispose(); 
    prenomController.dispose(); 
    mailController.dispose();
    ageController.dispose();
    idController.dispose();  
      
    super.dispose();
  }

  Future<Magasinier> fetchMagasinierBymail(String? mail) async {
    try {
      final response = await http.get(
        Uri.parse('$url/api/Magasinier/GetByMail?Mail=$mail'),
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        final List<dynamic> data = jsonDecode(response.body);
        magasinier =
            data.map((json) => Magasinier.fromJson(json)).toList().first;

        setState(() {
          nomController.text = magasinier.nom;
          prenomController.text = magasinier.prenom;
          mailController.text = magasinier.mail;
          ageController.text = magasinier.age.toString();
          idController.text = magasinier.idmagasinier.toString();
        });
      } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Magasinier',
            message: 'Failed to fetch magasinier by email',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        return magasinier;
      }
    } catch (e) {
      final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Magasinier',
            message: 'Failed to fetch magasinier by email $e',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      return magasinier;
    }
    return magasinier;
  }

  Future<bool> updateMagasinier() async {
    final id = magasinier.idmagasinier;
    final updatedMail = mailController.text;
    final updatednom = nomController.text;
    final updatedprenom = prenomController.text;
    final updatedage = ageController.text;

    final updatedMagasinier = MagasinierUpdate(
      
      nom: updatednom,
      prenom: updatedprenom,
      mail: updatedMail,
      age: int.parse(updatedage),
      adminRole: magasinier.adminRole,
    );

    final uri = Uri.parse(
      '$url/api/Magasinier/UpdatePassword?id=$id',
    );

    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedMagasinier.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode <= 399) {
      final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Update',
            message: 'updated successfully',
            contentType: ContentType.success,
          ),
        );
        
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      return true;
    } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Fail',
            message: 'Failed to update magasinier: ${response.statusCode}',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Colorie(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 150.0, bottom: 50.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    color: const Color.fromARGB(80, 255, 255, 255),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          const Row(
                            children: [
                              Text(
                                "     Nom",
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                            child: TextField(
                              controller: nomController,
                              readOnly: false,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ), // Add space between the text fields
                          const Row(
                            children: [
                              Text(
                                "     Prenom",
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                            child: TextField(
                              controller: prenomController,
                              readOnly: false,
                            ),
                          ),
                          const SizedBox(
                              height: 12), // Add space between the text fields
                          const Row(
                            children: [
                              Text(
                                "     Email",
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                            child: TextField(
                              controller: mailController,
                              readOnly: false,
                            ),
                          ),
                          const SizedBox(
                              height: 12), // Add space between the text fields
                          const Row(
                            children: [
                              Text(
                                "     Age",
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                            child: TextField(
                              controller: ageController,
                              readOnly: false,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () async {
                              final success = await updateMagasinier();
                              if (success) {
                                final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success',
            message: "Data updated successfully",
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
                              } else {
                                final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Fail',
            message: "Failed to save",
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF17203A),
                              ),
                            ),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Circle Avatar
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    top: -80,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/avaters/user.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
