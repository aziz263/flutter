import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sagem/Design/detailpicklist_table.dart';
import 'package:sagem/colories.dart';
import 'package:sagem/models/magasinier.dart';
import 'package:sagem/models/unite_de_stock.dart';
import 'package:sagem/screens/Magasinier_funct/magasinier_controller.dart';
import 'package:sagem/screens/detailpicklist_funct/api_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../models/detailpicklist.dart';
import '../authentification/scan_qr_code.dart';
import 'alldetailpicklistcreate.dart';

class DetailPicklistsView extends StatefulWidget {
  const DetailPicklistsView({super.key});

  @override
  DetailPicklistsViewState createState() => DetailPicklistsViewState();
}

class DetailPicklistsViewState extends State<DetailPicklistsView> {
  late List<DetailPicklist> detailPicklists = [];

  @override
  void initState() {
    super.initState();
    fetchDetailPicklists();
  }

  Future<void> servirAllDetails(String us) async {
    ApiHandler api = ApiHandler();
    UniteDeStock unite = await api.fetchUniteDeStock(us);
    List<DetailPicklist> dpl = await api.fetchByArticle(unite.article);
     SharedPreferences prefs = await SharedPreferences.getInstance();
        String? mail = prefs.getString('mail');
        MagasinierController magController = MagasinierController();
        Magasinier magasinier = await magController.getMagasinierBymail(mail);
        await api.addUsServie(
            magasinier.idmagasinier, unite.idUs, dpl.last.idDetailPickList);
        await api.addMouvement(
            magasinier.idmagasinier, unite.idUs, dpl.last.idDetailPickList);
    String response = await api.servirAllDetail(us);
    

    if (unite.quantite > 0) {
      if (response == "success") {
       
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'DetailPicklist',
            message: 'DetailPicklist servi successfully',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        Navigator.pop(context);
      } else if (response == "fail") {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'DetailPicklist',
            message: 'Failed Serving DetailPicklist ',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      } else if (response == "article does not exist") {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Article',
            message: 'article does not exist ',
            contentType: ContentType.failure,
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
            title: 'Erreur',
            message: 'Failed Serving DetailPickList ',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Article',
          message: "N'existe pas dans l'unité de Stock",
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<void> fetchDetailPicklists() async {
    final response = await http.get(
      Uri.parse('$url/api/DetailPickList'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        detailPicklists =
            data.map((item) => DetailPicklist.fromJson(item)).toList();

        detailPicklists.sort((a, b) {
          if (a.codeSt == "demandé" && b.codeSt != "demandé") {
            return -1;
          } else if (a.codeSt != "demandé" && b.codeSt == "demandé") {
            return 1;
          } else {
            return 0;
          }
        });
      });
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Fail',
          message: "Failed to fetch detail picklists: ${response.statusCode}",
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<void> _refreshData() async {
    await fetchDetailPicklists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Detail Picklists'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AllAddDetailPickList()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Scanner().qrCode(context, (code) {
                servirAllDetails(code!);
              });
            },
            icon: const Icon(Icons.qr_code, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Colorie(),
          RefreshIndicator(
            onRefresh: _refreshData,
            child: FutureBuilder(
              future: fetchDetailPicklists(),
              builder: (context, snapshot) {
                if (detailPicklists.isEmpty) {
                  return const Center(
                    child: Text(
                      'No details picklists available',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: detailPicklists.length,
                    itemBuilder: (context, index) {
                      var detailpicklist = detailPicklists[index];
                      Color? colorl;
                      if (detailpicklist.codeSt == "demandé") {
                        colorl = const Color.fromARGB(97, 248, 62, 81);
                      } else if (detailpicklist.codeSt == "servie") {
                        colorl = const Color.fromARGB(96, 39, 80, 40);
                      } else {
                        colorl = const Color.fromARGB(167, 255, 157, 0);
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 8),
                        child: DetailPicklistTable(
                          title:
                              "DetailPicklist : ${detailpicklist.idDetailPickList}",
                          article: detailpicklist.article,
                          emplacement: detailpicklist.emplacement,
                          codeSt: detailpicklist.codeSt,
                          quantite: detailpicklist.quantite,
                          colorl: colorl,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
