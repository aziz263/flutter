import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sagem/colories.dart';
import 'package:sagem/models/detailpicklist.dart';
import '../../models/article.dart';
import '../../models/detailpicklistadd.dart';
import 'api_handler.dart';

class AddDetailPickList extends StatefulWidget {
  final int id;

  const AddDetailPickList({super.key, required this.id});

  @override
  AddDetailPickListState createState() => AddDetailPickListState();
}

class AddDetailPickListState extends State<AddDetailPickList> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController controller;
  late TextEditingController controllerA;
  late TextEditingController quantitecontroller;
  late List<Article> articles;
  Article? selectedArticle;
  late String _selectedStatue = 'demandé';

  late Future<List<String>> articlesData;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    quantitecontroller = TextEditingController();
    controllerA = TextEditingController();
    articles = [];
    fetchArticles();
  }

  @override
  void dispose() {
    controller.dispose();
    controllerA.dispose();
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

  void addDetailPickList() async {
    if (_formKey.currentState!.validate()) {
      final detailpicklist = DetailPickListadd(
        emplacement: controller.text,
        quantite: int.parse(quantitecontroller.text),
      );

      final ApiHandler apiHandler = ApiHandler();

      int idSt = _selectedStatue.toLowerCase() == "servie" ? 2 : 1;
      final responseArticle = await apiHandler.getArticleByArticleData(selectedArticle!.articleData);
      final List<DetailPicklist> dpls = await apiHandler.fetchByArticle(selectedArticle!.articleData);
      bool existsInPicklist = dpls.any((detailPicklist) => detailPicklist.idPicklist == widget.id);

      if (!existsInPicklist) {
        if (responseArticle.idArticle! > 0) {
          final response = await apiHandler.addDetailPickList(
            detailpicklist: detailpicklist,
            idPickList: widget.id,
            idArticle: responseArticle.idArticle!,
            idSt: idSt,
          );

          if (response.statusCode >= 200 && response.statusCode <= 399) {
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
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          } else {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'DetailPickList',
                message: 'Failed to add DetailPickList',
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
              message: 'Failed to get Article',
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
      body: SingleChildScrollView(
        child: Stack(children: [
          const Colorie(),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(labelText: 'Emplacement'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: quantitecontroller,
                      decoration: const InputDecoration(labelText: 'Quantité'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<Article>(
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
                      validator: (value) {
                        if (value == null) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedStatue,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatue = value ?? 'demandé';
                        });
                      },
                      items: <String>['demandé', 'servie']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toLowerCase(),
                          child: Text(value),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: addDetailPickList,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF17203A),
                          ),
                        ),
                        child: const Text('Add')),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
