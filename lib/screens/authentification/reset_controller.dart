import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sagem/constants.dart';


class ResetController{

Future<http.Response> sendVereficationCode(String email) async {
    final uri =
        Uri.parse("$url/api/Magasinier/reset-password-request");
    late http.Response response;

    try {
      response = await http.post(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode(email),
      );
    } catch (e) {
      return response;
    }
    return response;
  }
Future<http.Response> resetPassword(String email,String token,String password) async {
    final uri =
        Uri.parse("$url/api/Magasinier/reset-password?token=$token&email=$email");
    late http.Response response;

    try {
      response = await http.post(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode(password),
      );
    } catch (e) {
      return response;
    }
    return response;
  }
}