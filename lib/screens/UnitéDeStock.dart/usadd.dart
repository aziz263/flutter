import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sagem/colories.dart';
import '../../models/Us_add.dart';
import '../../models/article.dart';
import 'uscontroller.dart';

class AddUs extends StatefulWidget {
  const AddUs({super.key});

  @override
  AddUsState createState() => AddUsState();
}

class AddUsState extends State<AddUs> {
  final TextEditingController _usController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  List<Article> articles = [];
  String? selectedArticle;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  void fetchArticles() async {
    final UsController controller = UsController();
    try {
      final List<Article> fetchedArticles = await controller.getArticle();
      setState(() {
        articles = fetchedArticles;
      });
    } catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Fail',
          message: "Failed to fetch articles",
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<void> _addUs() async {
    final String us = _usController.text.trim();
    final String quantite = _quantiteController.text.trim();
    final String? article = selectedArticle;
    if (us.isNotEmpty && article != null) {
      final news = UsAdd(
        us: us,
        article: article,
        quantite: quantite,
      );
      try {
        final UsController controller = UsController();
        final http.Response response = await controller.addUs(us: news);
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success',
              message: "Us ajouté avec succès",
              contentType: ContentType.success,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          Navigator.pop(context, true);
        } else {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Fail',
              message: "Failed to add Us: ${response.statusCode}",
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      } catch (e) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Fail',
            message: "Failed to add Us: $e",
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
        title: const Text("Add Us"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(children: [
        const Colorie(),
        Padding(
          padding: const EdgeInsets.only(top: 120.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _usController,
                decoration: const InputDecoration(labelText: 'Us'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedArticle,
                decoration: const InputDecoration(labelText: 'Article'),
                items: articles.map((Article article) {
                  return DropdownMenuItem<String>(
                    value:
                        article.articleData,
                    child: Text(article.articleData),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedArticle = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _quantiteController,
                decoration: const InputDecoration(labelText: 'Quantité'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: Center(
                  child: ElevatedButton(
                    onPressed: _addUs,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFF17203A),
                      ),
                    ),
                    child: const Text('Add Us'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
