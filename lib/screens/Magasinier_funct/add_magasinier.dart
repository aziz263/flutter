import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sagem/colories.dart';
import '../../constants.dart';
import '../../models/magasinier.dart';

class AddMagasinier extends StatefulWidget {
  const AddMagasinier({super.key});

  @override
  AddMagasinierState createState() => AddMagasinierState();
}

class AddMagasinierState extends State<AddMagasinier> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _qrCodeController = TextEditingController();
  String? _selectedRole;

  Future<void> _addMagasinier() async {
    const int idMagasinier = 0;
    final String nom = _nomController.text;
    final String prenom = _prenomController.text;
    final String mail = _mailController.text;
    final String password = _passwordController.text;
    final int age = int.parse(_ageController.text);
    final int role = _selectedRole == 'Magasinier' ? 0 : 1;
    final int qrCode = int.parse(_qrCodeController.text);

    final newMagasinier = Magasinier(
      idmagasinier: idMagasinier,
      nom: nom,
      prenom: prenom,
      mail: mail,
      password: password,
      age: age,
      adminRole: role,
      qrCode: qrCode,
    );

    final response = await http.post(
      Uri.parse('$url/api/Magasinier/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(newMagasinier.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success',
          message: "Magasinier added successfully",
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      Navigator.pop(context);
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Fail',
          message: "Failed to add magasinier: ${response.statusCode}",
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Add Magasinier"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(children: [
        const Colorie(),
        Padding(
          padding: const EdgeInsets.only(top: 120.0, left: 25.0, right: 25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _prenomController,
                  decoration: const InputDecoration(labelText: 'Prenom'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _mailController,
                  decoration: const InputDecoration(labelText: 'Mail'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: const [
                    DropdownMenuItem(
                        value: 'Magasinier', child: Text('Magasinier')),
                    DropdownMenuItem(
                        value: 'Chef Magasin', child: Text('Chef Magasin')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _qrCodeController,
                  decoration: const InputDecoration(labelText: 'N° serie'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _addMagasinier,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF17203A),
                      ),
                    ),
                    child: const Text('Add Magasinier'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
