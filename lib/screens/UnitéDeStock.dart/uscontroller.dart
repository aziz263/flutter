import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sagem/models/Us_add.dart';
import 'package:sagem/models/article.dart';
import 'package:sagem/models/unite_de_stock.dart';
import '../../constants.dart';

class UsController {
  Future<List<UniteDeStock>> getUs() async {
    List<UniteDeStock> data = [];

    final uri = Uri.parse("$url/api/Unité_De_Stock");
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => UniteDeStock.fromJson(json)).toList();
      }
    } catch (e) {
      return data;
    }

    return data;
  }

  Future<http.Response> addUs({required UsAdd us}) async {
    final uri = Uri.parse("$url/api/Unité_De_Stock");
    late http.Response response;

    try {
      response = await http.post(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode(us),
      );
    } catch (e) {
      return response;
    }
    return response;
  }

   Future<List<Article>> getArticle() async {
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
}
