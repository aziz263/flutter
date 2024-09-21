import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sagem/colories.dart';

import '../../constants.dart';
import '../../models/magasinier.dart';

class MagasinierUpdated extends StatefulWidget {
  final Magasinier magasinier;

  const MagasinierUpdated({super.key, required this.magasinier});

  @override
  MagasinierUpdatedState createState() => MagasinierUpdatedState();
}

class MagasinierUpdatedState extends State<MagasinierUpdated> {
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final mailController = TextEditingController();
  final ageController = TextEditingController();
  final qrCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final idController = TextEditingController();

  late int adminRole;

  @override
  void initState() {
    super.initState();
    nomController.text = widget.magasinier.nom;
    prenomController.text = widget.magasinier.prenom;
    mailController.text = widget.magasinier.mail;
    ageController.text = widget.magasinier.age.toString();
    adminRole = widget.magasinier.adminRole;
    qrCodeController.text = widget.magasinier.qrCode.toString();
    passwordController.text = '';
  }

  Future<bool> updateMagasinier() async {
    final id = widget.magasinier.idmagasinier;
    final updatedMail = mailController.text;
    final updatedNom = nomController.text;
    final updatedPrenom = prenomController.text;
    final updatedAge = ageController.text;
    final updatedAdminRole = adminRole.toString();
    final updatedQrCode = qrCodeController.text;
    final updatedPassword = passwordController.text;

    final updatedMagasinier = Magasinier(
      idmagasinier: id,
      nom: updatedNom,
      prenom: updatedPrenom,
      mail: updatedMail,
      password: updatedPassword.isEmpty
          ? widget.magasinier.password
          : updatedPassword,
      age: int.parse(updatedAge),
      adminRole: int.parse(updatedAdminRole),
      qrCode: int.parse(updatedQrCode),
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
          message: 'Updated successfully',
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Compte Update',
        ),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const Colorie(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
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
                  ),
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
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Text(
                        "     Admin Role",
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                    child: DropdownButtonFormField<int>(
                      value: adminRole,
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Chef Magasin'),
                        ),
                        DropdownMenuItem(
                          value: 0,
                          child: Text('Magasinier'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          adminRole = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Text(
                        "     QR Code",
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                    child: TextField(
                      controller: qrCodeController,
                      readOnly: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Text(
                        "     Password",
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                    child: TextField(
                      controller: passwordController,
                      readOnly: false,
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () async {
                      final success = await updateMagasinier();

                      if (success) {
                        Navigator.of(context).pop();
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
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFF17203A),
                      ),
                    ),
                    child: const Text('Save'),
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
