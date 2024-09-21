import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sagem/colories.dart';
import 'package:sagem/models/article.dart';
import 'package:sagem/screens/article_funct.dart/article_controller.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({super.key});

  @override
  AddArticleState createState() => AddArticleState();
}

class AddArticleState extends State<AddArticle> {
  final TextEditingController _nomArticleController = TextEditingController();

  Future<void> _addMagasin() async {
    final String nomArticle = _nomArticleController.text.trim();
    if (nomArticle.isNotEmpty) {
      final newArticle = Article(articleData: nomArticle);
      try {
        final ArticleController controller = ArticleController();
        final http.Response response =
            await controller.addArticle(article: newArticle);
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Article',
              message: 'Article added successfully',
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
              title: 'Article',
              message: 'Error adding Article: ${response.statusCode}',
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'Failed to add Article. Please try again later.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Article',
            message: 'Error adding Article: $e',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'An error occurred while adding Article. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Add Articles"),
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
                controller: _nomArticleController,
                decoration: const InputDecoration(labelText: 'Nom Article'),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  child: Center(
                child: ElevatedButton(
                    onPressed: _addMagasin,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF17203A),
                      ),
                    ),
                    child: const Text('Add Article')),
              )),
            ],
          ),
        ),
      ]),
    );
  }
}
