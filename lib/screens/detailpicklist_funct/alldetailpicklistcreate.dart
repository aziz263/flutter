import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sagem/colories.dart';
import 'package:sagem/models/detailpicklist.dart';

import '../../models/article.dart';
import '../../models/detailpicklistadd.dart';
import '../../models/picklist.dart';
import 'api_handler.dart';

class AllAddDetailPickList extends StatefulWidget {
  const AllAddDetailPickList({super.key});

  @override
  AddDetailPickListState createState() => AddDetailPickListState();
}

class AddDetailPickListState extends State<AllAddDetailPickList> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerN = TextEditingController();
  final TextEditingController controllerS = TextEditingController();
  final TextEditingController controllerP = TextEditingController();
  final TextEditingController quantitecontroller = TextEditingController();
  String _selectedStatue = 'demandé';
  List<Article> articles = [];
  List<PickList> picklists = [];
  Article? selectedArticle;
  PickList? selectedPickList;

  @override
  void initState() {
    super.initState();
    fetchArticles();
    fetchPickLists();
  }

  @override
  void dispose() {
    controller.dispose();
    controllerN.dispose();
    controllerS.dispose();
    controllerP.dispose();
    quantitecontroller.dispose();
    super.dispose();
  }

  void fetchArticles() async {
    final controller = ApiHandler();
    final fetchedArticles = await controller.getArticlesData();
    setState(() {
      articles = fetchedArticles;
    });
  }

  void fetchPickLists() async {
    final controller = ApiHandler();
    final fetchedPickLists = await controller.fetchPicklists();
    setState(() {
      picklists = fetchedPickLists;
    });
  }

  void addDetailPickList() async {
    if (_formKey.currentState!.validate()) {
      if (selectedArticle == null || selectedPickList == null) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Fail',
            message: 'Please select an article and a picklist',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }

      final detailpicklist = DetailPickListadd(
        emplacement: controller.text,
        quantite: int.parse(quantitecontroller.text),
      );

      final ApiHandler apiHandler = ApiHandler();

      int idSt = _selectedStatue.toLowerCase() == "servie" ? 2 : 1;
      final responseArticle = await apiHandler
          .getArticleByArticleData(selectedArticle!.articleData);
      final List<DetailPicklist> dpls = await apiHandler.fetchByArticle(selectedArticle!.articleData);

      bool existsInPicklist = dpls.any((detailPicklist) => detailPicklist.idPicklist == selectedPickList!.idPickList);
      if(!existsInPicklist){ 
      if (responseArticle.idArticle! > 0) {
        final response = await apiHandler.addDetailPickList(
          detailpicklist: detailpicklist,
          idPickList: selectedPickList!.idPickList,
          idArticle: responseArticle.idArticle!,
          idSt: idSt,
        );

        if (response.statusCode >= 200 && response.statusCode <= 399) {
          await apiHandler.updatePicklistStatue(selectedPickList!.idPickList);
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'DetailPickList',
              message: 'DetailPickList added successfully',
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
              message: "Error adding DetailPickList",
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
            title: 'Fail',
            message: 'Article not found',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
      }
      else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Article',
            message: 'Article exists in Picklist',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }

  Widget buildEmplacementField() {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Emplacement'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget buildArticleField() {
    return DropdownButtonFormField<Article>(
      value: selectedArticle,
      onChanged: (value) {
        setState(() {
          selectedArticle = value;
        });
      },
      items: articles.map((article) {
        return DropdownMenuItem<Article>(
          value: article,
          child: Text(article.articleData),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Article',
      ),
    );
  }

  Widget buildQuantiteField() {
    return TextFormField(
      controller: quantitecontroller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'Quantité'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget buildNumeroPickListField() {
    return DropdownButtonFormField<PickList>(
      value: selectedPickList,
      onChanged: (value) {
        setState(() {
          selectedPickList = value;
        });
      },
      items: picklists.map((picklist) {
        return DropdownMenuItem<PickList>(
          value: picklist,
          child: Text('PickList ${picklist.idPickList}'),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'PickLists',
      ),
    );
  }

  Widget buildStatueField() {
    return DropdownButtonFormField<String>(
      value: _selectedStatue,
      onChanged: (value) {
        setState(() {
          _selectedStatue = value ?? 'servie';
        });
      },
      items: <String>['demandé', 'servie']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value.toLowerCase(),
          child: Text(value),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Statue',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Add DetailPickList"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(children: [
        const Colorie(),
        Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 100),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildEmplacementField(),
                    const SizedBox(height: 20),
                    buildArticleField(),
                    const SizedBox(height: 20),
                    buildQuantiteField(),
                    const SizedBox(height: 20),
                    buildNumeroPickListField(),
                    const SizedBox(height: 20),
                    buildStatueField(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: addDetailPickList,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF17203A),
                        ),
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
