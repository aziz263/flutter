import 'dart:async';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import 'package:sagem/Design/detailpicklist_table.dart';
import 'package:sagem/colories.dart';
import 'package:sagem/models/magasinier.dart';
import 'package:sagem/models/unite_de_stock.dart';
import 'package:sagem/screens/Magasinier_funct/magasinier_controller.dart';
import 'package:sagem/screens/authentification/scan_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../models/article.dart';
import '../../models/detailpicklist.dart';
import '../detailpicklist_funct/detailpicklistcreate.dart';
import 'api_handler.dart';
import 'detailpicklistdata.dart';

class DetailPicklistScreen extends StatefulWidget {
  final int id;
  final List<dynamic> detailPicklists;

  const DetailPicklistScreen({
    super.key,
    required this.id,
    this.detailPicklists = const [],
  });

  @override
  DetailPicklistScreenState createState() => DetailPicklistScreenState();
}

class DetailPicklistScreenState extends State<DetailPicklistScreen> {
  late List<DetailPicklist> detailPicklists = [];
  late ApiHandler apiHandler = ApiHandler();
  late List<Article> articles = [];
  late List<String> articleOptions = [];
  late List<DetailPicklist> emplacements = [];
  late List<String> emplacementOptions = [];
  late List<String> uniqueEmplacementList = [];

  List<dynamic> selectedArticles = [];
  List<dynamic> selectedEmplacements = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchArticles();
    fetchEmplacements();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    final id = widget.id;
    final response = await http.get(
      Uri.parse(
        '$url/api/DetailPickList/Id_PickList?id=$id',
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      setState(() {
        detailPicklists =
            jsonData.map((json) => DetailPicklist.fromJson(json)).toList();
        applyFilters();
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

  void fetchArticles() async {
    final controller = ApiHandler();
    final fetchedArticles = await controller.getArticlesData();
    setState(() {
      articles = fetchedArticles;
      articleOptions = articles.map((article) => article.articleData).toList();
    });
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
    String response = await api.servirDetailByIdPicklist(widget.id, us);

    
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

  void fetchEmplacements() async {
    final ApiHandler apiHandler = ApiHandler();
    try {
      final List<DetailPicklist> fetchEmplacements =
          await apiHandler.getemplacement();
      setState(() {
        emplacementOptions = fetchEmplacements
            .map((detailPicklist) => detailPicklist.emplacement)
            .toList();
        Set<String> uniqueEmplacements = Set.from(emplacementOptions);
        uniqueEmplacementList = uniqueEmplacements.toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch emplacements'),
            duration: Duration(seconds: 2),
          ),
        );
    }
  }

  Future<void> _refreshData() async {
    await fetchData();
  }

  void applyFilters() {
    setState(() {
      detailPicklists = detailPicklists.where((detailPicklist) {
        bool matchesArticle = selectedArticles.isEmpty ||
            selectedArticles.contains(detailPicklist.article);
        bool matchesEmplacement = selectedEmplacements.isEmpty ||
            selectedEmplacements.contains(detailPicklist.emplacement);
        return matchesArticle && matchesEmplacement;
      }).toList();
    });
  }

  void handleSelectionChange() {
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final int id = widget.id;
    detailPicklists.sort((a, b) {
      if (a.codeSt == "demandé" && b.codeSt != "demandé") {
        return -1;
      } else if (a.codeSt != "demandé" && b.codeSt == "demandé") {
        return 1;
      } else {
        return 0;
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('DetailPicklists'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          PopupMenuButton<String>(
            color: const Color.fromARGB(221, 213, 213, 213),
            icon: const Icon(Icons.filter_list),
            onSelected: (String result) {
              setState(() {
                switch (result) {
                  case 'Articles':
                    fetchArticles();
                    break;
                  case 'Emplacements':
                    fetchEmplacements();
                    break;
                  default:
                    fetchData();
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Articles',
                child: SizedBox(
                  height: 70,
                  width: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MultiSelectDropdown.simpleList(
                          whenEmpty: 'Articles',
                          checkboxFillColor:
                              const Color.fromARGB(221, 213, 213, 213),
                          splashColor: Colors.blue,
                          width: 200,
                          list: articleOptions,
                          initiallySelected: const [],
                          onChange: (newList) {
                            selectedArticles = newList;
                            handleSelectionChange();
                          },
                          includeSearch: false,
                          includeSelectAll: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'Emplacements',
                child: SizedBox(
                  height: 70,
                  width: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MultiSelectDropdown.simpleList(
                          whenEmpty: 'Emplacements',
                          checkboxFillColor:
                              const Color.fromARGB(233, 213, 213, 213),
                          splashColor: Colors.blue,
                          width: 200,
                          list: uniqueEmplacementList,
                          initiallySelected: const [],
                          onChange: (newList) {
                            selectedEmplacements = newList;
                            handleSelectionChange();
                          },
                          includeSearch: false,
                          includeSelectAll: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const Colorie(),
          RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: detailPicklists.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var detailPicklist = detailPicklists[index];
                            Color cardColor =
                                const Color.fromARGB(96, 39, 80, 40);
                            if (detailPicklist.codeSt == "demandé") {
                              cardColor = const Color.fromARGB(98, 248, 62, 81);
                            } else if (detailPicklist.codeSt ==
                                "etat transitoire") {
                              cardColor =
                                  const Color.fromARGB(167, 255, 157, 0);
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: DetailPicklistTable(
                                title:
                                    "DetailPicklist : ${detailPicklist.idDetailPickList}",
                                article: detailPicklist.article,
                                emplacement: detailPicklist.emplacement,
                                codeSt: detailPicklist.codeSt,
                                quantite: detailPicklist.quantite,
                                colorl: cardColor,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPickListData(
                                        id: id,
                                        detailPicklist: detailPicklists[index],
                                        currentIndex: index,
                                        detailPicklists: detailPicklists,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          itemCount: detailPicklists.length,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDetailPickList(id: id),
            ),
          );
        },
        backgroundColor: const Color(0xFF17203A),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
