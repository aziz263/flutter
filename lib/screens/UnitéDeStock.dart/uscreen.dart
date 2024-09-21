import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sagem/colories.dart';
import 'package:sagem/models/unite_de_stock.dart';
import '../../Design/us_card.dart';
import 'usadd.dart';
import 'uscontroller.dart';


class UsView extends StatefulWidget {
  const UsView({super.key});

  @override
  UsViewState createState() => UsViewState();
}

class UsViewState extends State<UsView> {
  List<UniteDeStock> uss = [];

  @override
  void initState() {
    super.initState();
    fetchUss();
  }

  Future<void> fetchUss() async {
    try {
      final controller = UsController();
      final fetchedUss = await controller.getUs();
      setState(() {
        uss = fetchedUss;
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
    await fetchUss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Unité de Stocks'),
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
            MaterialPageRoute(builder: (context) => const AddUs()),
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
              itemCount: uss.length,
              itemBuilder: (context, index) {
                var us = uss[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16.0,
                  ),
                  child: UsTable(
                    title: 'Us ${us.idUs} ',
                    us: ' ${us.us}',
                    article: ' ${us.article}',
                    quantite: ' ${us.quantite}',
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
