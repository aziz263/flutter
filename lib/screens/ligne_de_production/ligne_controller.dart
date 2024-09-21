import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../models/ligne.dart';
import '../../models/ligne_add.dart';

class LigneController {
  Future<List<Ligne>> getLigne() async {
    List<Ligne> data = [];

    final uri = Uri.parse("$url/api/LigneDeProduction");
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => Ligne.fromJson(json)).toList();
      }
    } catch (e) {
      return data;
    }

    return data;
  }

  Future<http.Response> addUs({required LigneAdd us}) async {
    final uri = Uri.parse("$url/api/LigneDeProduction");
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
}
