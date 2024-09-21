import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sagem/colories.dart';
import 'package:sagem/models/magasinier.dart';
import 'package:sagem/models/unite_de_stock.dart';
import 'package:sagem/screens/Magasinier_funct/magasinier_controller.dart';
import 'package:sagem/screens/detailpicklist_funct/api_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../models/detailpicklist.dart';
import '../../models/picklist.dart';
import '../authentification/scan_qr_code.dart';

class DetailPickListData extends StatefulWidget {
  final DetailPicklist detailPicklist;
  final List<DetailPicklist> detailPicklists;
  final int currentIndex;
  final int id;

  const DetailPickListData({
    super.key,
    required this.id,
    required this.detailPicklist,
    required this.detailPicklists,
    required this.currentIndex,
  });

  @override
  DetailPickListState createState() => DetailPickListState();
}

class DetailPickListState extends State<DetailPickListData> {
  // ignore: non_constant_identifier_names
  late Future<List<PickList>> PicklistsFuture;

  late PickList picklist;

  @override
  void initState() {
    super.initState();
    PicklistsFuture = _fetchPicklists(widget.id);
  }

  Future<void> servirDetails(DetailPicklist dpl, String us) async {
    ApiHandler api = ApiHandler();
    UniteDeStock unite = await api.fetchUniteDeStock(us);
    SharedPreferences prefs = await SharedPreferences.getInstance();
        String? mail = prefs.getString('mail');
        MagasinierController magController = MagasinierController();
        Magasinier magasinier = await magController.getMagasinierBymail(mail);

        await api.addUsServie(
            magasinier.idmagasinier, unite.idUs, dpl.idDetailPickList);
        await api.addMouvement(
            magasinier.idmagasinier, unite.idUs, dpl.idDetailPickList);
    String response = await api.servirDetail(dpl, us);
    
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

  Future<List<PickList>> _fetchPicklists(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$url/api/PickList/Id?id=$id'),
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        
        final List<dynamic> PicklistsData = jsonDecode(response.body);
        return PicklistsData.map((data) => PickList.fromJson(data)).toList();
      } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Fail',
            message: 'Failed to fetch picklists: ${response.statusCode} ',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Fail',
          message: 'Failed to fetch picklists: $e ',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      rethrow;
    }
  }

  Widget _buildDetailItem(String label, String value, {IconData? icon}) {
    return Card(
      color: Colors.transparent,
      elevation: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
            size: 24.0,
          ),
          title: Text(
            '$label $value',
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPreviousDetailPicklist() {
    int previousIndex =
        (widget.currentIndex - 1 + widget.detailPicklists.length) %
            widget.detailPicklists.length;
    DetailPicklist previousDetailPicklist =
        widget.detailPicklists[previousIndex];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPickListData(
          id: widget.id,
          detailPicklist: previousDetailPicklist,
          detailPicklists: widget.detailPicklists,
          currentIndex: previousIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PickList>>(
      future: PicklistsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        picklist = snapshot.data![0];

        return Material(
          color: Colors.transparent,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: const Text('Detail Picklist'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 20),
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
              ),
            ),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  const Colorie(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 105),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem(
                            'PickList', picklist.idPickList.toString(),
                            icon: Icons.code),
                        const SizedBox(height: 16.0),
                        _buildDetailItem('Magasin', picklist.nomMagasin,
                            icon: Icons.storage),
                        _buildDetailItem('Ligne', picklist.numLigne.toString(),
                            icon: Icons.format_line_spacing),
                        _buildDetailItem(
                            'Article:', widget.detailPicklist.article,
                            icon: Icons.description),
                        _buildDetailItem(
                            'Emplacement:', widget.detailPicklist.emplacement,
                            icon: Icons.place),
                        _buildDetailItem(
                            'Statut:', widget.detailPicklist.codeSt,
                            icon: Icons.flag),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: _navigateToPreviousDetailPicklist,
                              icon: const Icon(
                                Icons.arrow_left,
                                size: 60,
                              ),
                              color: const Color(0xFF17203A),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Scanner().qrCode(context, (code) {
                                  servirDetails(widget.detailPicklist, code!);
                                  Navigator.pop(context);
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xFF17203A),
                                ),
                              ),
                              child: const Text('Scan'),
                            ),
                            IconButton(
                              onPressed: _navigateToPreviousDetailPicklist,
                              icon: const Icon(Icons.arrow_right),
                              iconSize: 65,
                              color: const Color(0xFF17203A),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
