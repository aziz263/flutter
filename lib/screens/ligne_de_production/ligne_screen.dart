import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sagem/colories.dart';
import '../../Design/ligne_card.dart';
import '../../models/ligne.dart';
import 'ligne_add.dart';
import 'ligne_controller.dart';

class LigneView extends StatefulWidget {
  const LigneView({super.key});

  @override
  LigneViewState createState() => LigneViewState();
}

class LigneViewState extends State<LigneView> {
  List<Ligne> lignes = [];

  @override
  void initState() {
    super.initState();
    fetchLignes();
  }

  Future<void> fetchLignes() async {
    try {
      final controller = LigneController();
      final fetchedLignes = await controller.getLigne();
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
          message: 'Error fetching ligne: $e',
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<void> _refreshData() async {
    await fetchLignes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Lignes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddLigne()),
          );
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
            onRefresh: _refreshData,
            child: ListView.builder(
              itemCount: lignes.length,
              itemBuilder: (context, index) {
                var ligne = lignes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16.0,
                  ),
                  child: LigneTable(
                    title: 'Ligne ${ligne.idLigne} ',
                    numLigne: ' ${ligne.numLigne}',
                    colorl: const Color.fromARGB(96, 0, 48, 144),
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
