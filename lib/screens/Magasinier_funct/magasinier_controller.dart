import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../../models/magasinier.dart';

class MagasinierController {
  late Magasinier magasinier;

  Future<Magasinier> getMagasinierBymail(String? mail) async {
    try {
      final response = await http.get(
        Uri.parse('$url/api/Magasinier/GetByMail?Mail=$mail'),
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        final List<dynamic> data = jsonDecode(response.body);
        magasinier = data.map((json) => Magasinier.fromJson(json)).toList().first;
      } else {
        log('Failed to fetch magasinier by mail: ${response.statusCode}');
        return magasinier;
      }
    } catch (e) {
      log('Error fetching magasinier by mail: $e');
      return magasinier;
    }
    return magasinier;
  }
}
