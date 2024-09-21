import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sagem/colories.dart';

import 'package:sagem/screens/article_funct.dart/add_article.dart';

import '../../Design/article_card.dart';
import '../../models/article.dart';
import 'article_controller.dart';

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ArticlesViewState createState() => ArticlesViewState();
}

class ArticlesViewState extends State<ArticlesView> {
  List<Article> articles = []; // Define magasiniers list here

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      final controller = ArticleController();
      final fetchedArticles = await controller.getArticles();
      setState(() {
        articles = fetchedArticles;
      });
    } catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Article',
          message: 'Error fetching articles: $e',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<void> _refreshData() async {
    await fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Articles'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddArticle()),
          );
        },
        backgroundColor: const Color(0xFF17203A),
        child: const Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          const Colorie(),
          RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                var article = articles[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16.0,
                  ),
                  child: ArticleTable(
                    title: 'Article ${article.idArticle} ',
                    articleData: ' ${article.articleData}',
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
