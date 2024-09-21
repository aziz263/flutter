import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sagem/colories.dart';

import '../../Design/magasin_card.dart';
import '../../models/magasin.dart';
import 'addmagasin_screen.dart';
import 'magasin_controller.dart';

class MagasinsView extends StatefulWidget {
  const MagasinsView({super.key});

  @override
  MagasinsViewState createState() => MagasinsViewState();
}

class MagasinsViewState extends State<MagasinsView> {
  List<Magasin> magasins = [];

  @override
  void initState() {
    super.initState();
    fetchMagasins();
  }

  Future<void> fetchMagasins() async {
    try {
      final controller = MagasinController();
      final fetchedMagasins = await controller.getMagasins();
      setState(() {
        magasins = fetchedMagasins;
      });
    } catch (e) {
      final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Fail',
            message: 'Error fetching magasins: $e',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
    }
  }

  Future<void> _refreshData() async {
    await fetchMagasins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Magasins'),
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
            MaterialPageRoute(builder: (context) => const AddMagasin()),
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
              itemCount: magasins.length,
              itemBuilder: (context, index) {
                var magasin = magasins[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16.0,
                  ),
                  child: MagasinTable(
                    title: 'Magasin ${magasin.idMg} ',
                    nomMg: ' ${magasin.nomMg}',
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
