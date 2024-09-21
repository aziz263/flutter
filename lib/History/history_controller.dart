import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../models/usservie.dart';

class HistoryController {
  Future<List<UsServie>> getUsServies() async {
    List<UsServie> data = [];

    final uri = Uri.parse("$url/api/UsServi");
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => UsServie.fromJson(json)).toList();
      }
    } catch (e) {
      return data;
    }
  return data;
  }
}
