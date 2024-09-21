import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../constants.dart';

import '../../models/magasin.dart';
import '../../models/magasinadd.dart';

class MagasinController {
  Future<List<Magasin>> getMagasins() async {
    List<Magasin> data = [];

    final uri = Uri.parse("$url/api/Magasin");
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => Magasin.fromJson(json)).toList();
      }
    } catch (e) {
      return data;
    }

    return data;
  }

  Future<http.Response> addMagasin({required MagasinAdd magasin}) async {
    final uri = Uri.parse("$url/api/Magasin");
    late http.Response response;

    try {
      response = await http.post(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode(magasin),
      );
    } catch (e) {
      return response;
    }
    return response;
  }
}
