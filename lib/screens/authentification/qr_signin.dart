import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:sagem/constants.dart';
import 'package:sagem/models/magasinier.dart';

class QrSingIn {
  Future<Magasinier> getMagasinierQrCode(String? qrCode) async {
    if (qrCode == null || qrCode.isEmpty) {
      throw Exception('Invalid QR code');
    }
    try {
      final response = await http.get(
        Uri.parse('$url/api/Magasinier/GetByQrCode?QrCode=$qrCode'),
      );
      

      if (response.statusCode >= 200 && response.statusCode <= 399) {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          log('Decoded JSON: $data');
          if (data.isNotEmpty) {
            return Magasinier.fromJson(data);
          } else {
            throw Exception('No data received');
          }
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching magasinier: $e');
      throw Exception('Failed to fetch magasinier');
    }
  }
} 
