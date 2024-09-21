import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Design/magasinier_card.dart';
import '../../colories.dart';
import '../../constants.dart';
import '../../models/magasinier.dart';
import 'add_magasinier.dart';
import 'magasinier_update.dart';

class MagasiniersView extends StatefulWidget {
  const MagasiniersView({super.key});

  @override
  MagasiniersViewState createState() => MagasiniersViewState();
}

class MagasiniersViewState extends State<MagasiniersView> {
  List<Magasinier> magasiniers = [];

  @override
  void initState() {
    super.initState();
    fetchMagasiniers();
  }

  Future<void> fetchMagasiniers() async {
    try {
      final response = await http.get(
        Uri.parse('$url/api/Magasinier'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          magasiniers = data.map((item) => Magasinier.fromJson(item)).toList();
        });
      } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Fail',
            message: 'Failed to fetch magasiniers: ${response.statusCode}',
            contentType: ContentType.failure,
          ),
        );
        
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (error) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Fail',
          message: 'Failed to fetch magasiniers: $error',
          contentType: ContentType.failure,
        ),
      );
      
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<void> _refreshData() async {
    await fetchMagasiniers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Magasiniers',
        ),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMagasinier()),
          );
        },
        backgroundColor: const Color(0xFF17203A),
        child: const Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
      body: SizedBox(
        child: Stack(
          children: [
            const Colorie(),
            RefreshIndicator(
              onRefresh: _refreshData,
              child: magasiniers.isEmpty
                  ? const Center(
                      child: Text(
                        'No magasiniers available',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: magasiniers.length,
                      itemBuilder: (context, index) {
                        var magasinier = magasiniers[index];
                        String role = magasinier.adminRole == 1
                            ? "Chef Magasinier"
                            : "Magasinier";
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 8),
                          child: MagasinierCard(
                            title: "Magasinier : ${magasinier.idmagasinier}",
                            mail: magasinier.mail,
                            nom: magasinier.nom,
                            prenom: magasinier.prenom,
                            age: "${magasinier.age}",
                            adminRole: role,
                            qrCode: magasinier.qrCode,
                            colorl: const Color.fromARGB(96, 0, 48, 144),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MagasinierUpdated(magasinier: magasinier),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
