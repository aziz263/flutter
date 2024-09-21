import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sagem/constants.dart';
import 'package:sagem/models/article.dart';
import 'package:sagem/models/magasinier.dart';

class Controller {
  
  Future<Magasinier> getMagasinierOfTheMonth() async {
    List<Magasinier> magasinier = [];    
    try {
      final response = await http.get(
        Uri.parse('$url/api/UsServi/MagasinierOfTheMonth'),
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        final List<dynamic> data = jsonDecode(response.body);
        magasinier = data.map((json) => Magasinier.fromJson(json)).toList();
        return magasinier.first;
      }else {
        return magasinier.first;
      }
    }catch(e){
      return magasinier.first;
    }
  }
  Future<Article> getArticleOfTheMonth() async {
    List<Article> article = [];    
    try {
      final response = await http.get(
        Uri.parse('$url/api/UsServi/ArticleOfTheMonth'),
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        final List<dynamic> data = jsonDecode(response.body);
        article = data.map((json) => Article.fromJson(json)).toList();
        return article.first;
      }else {
        return article.first;
      }
    }catch(e){
      return article.first;
    }
  }
}
