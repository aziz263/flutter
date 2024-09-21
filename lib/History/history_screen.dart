import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sagem/colories.dart';

import '../../models/usservie.dart';
import '../Design/history_card.dart';
import 'history_controller.dart';

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  late List<UsServie> usServis;

  @override
  void initState() {
    super.initState();
    usServis = [];
    getUsServies();
  }

  Future<void> getUsServies() async {
    try {
      HistoryController historyController = HistoryController();
      usServis = await historyController.getUsServies();
      setState(() {});
    } catch (e) {
      log('Error fetching unité de stock data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Stack(
        children: [
          const Colorie(),
          if (usServis.isEmpty)
            const Center(
              child: Text(
                'No Us servie available',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            RefreshIndicator(
              onRefresh: getUsServies,
              child: ListView.builder(
                itemCount: usServis.length,
                itemBuilder: (context, index) {
                  var usServi = usServis[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: HistoryCard(
                      title: '${usServi.idUsServi}',
                      mail: usServi.mail,
                      quantite: usServi.quantite,
                      emplacement: usServi.emplacement,
                      us: usServi.us,
                      idPicklist: usServi.idPicklist,
                      idDeatilpicklist: usServi.idDetailPicklist,
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
