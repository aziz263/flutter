import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../models/article.dart';

class ArticleController {
  Future<List<Article>> getArticles() async {
    List<Article> data = [];

    final uri = Uri.parse("$url/api/Article");
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => Article.fromJson(json)).toList();
      }
    } catch (e) {
      return data;
    }

    return data;
  }
  Future<http.Response> addArticle({required Article article}) async {
    final uri = Uri.parse("$url/api/Article");
    late http.Response response;

    try {
      response = await http.post(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode(article),
      );
    } catch (e) {
      return response;
    }
    return response;
  }
}
