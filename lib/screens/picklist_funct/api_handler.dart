import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../constants.dart';

import '../../models/ligne.dart';
import '../../models/magasin.dart';
import '../../models/picklist.dart';
import '../../models/picklistadd.dart';

class ApiHandler {
  Future<http.Response> addPickList(
      {required PickListadd picklist,
      required int idMg,
      required int idLigne,
      required int idSt}) async {
    final uri =
        Uri.parse("$url/api/PickList?Id_mg=$idMg&IdLigne=$idLigne&Id_St=$idSt");
    late http.Response response;

    try {
      response = await http.post(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode(picklist),
      );
    } catch (e) {
      return response;
    }
    return response;
  }

  Future<Magasin> getMagasinByNom(String nomMagasin) async {
    List<Magasin> data = [];

    final uri = Uri.parse("$url/api/Magasin/GetByNomMagasin?NomMg=$nomMagasin");
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
      return data.first;
    }

    return data.first;
  }

  Future<Ligne> getLigneByNum(int numLigne) async {
    List<Ligne> data = [];

    final uri =
        Uri.parse("$url/api/LigneDeProduction/NumLigne?NumLigne=$numLigne");
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => Ligne.fromJson(json)).toList();
      }
    } catch (e) {
      return data.first;
    }
    return data.first;
  }

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
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => Ligne.fromJson(json)).toList();
      }
    } catch (e) {
      return data; // return empty list on error
    }
    return data;
  }

  Future<List<PickList>> fetchPicklistsByMagasin(String nom) async {
    List<PickList> data = [];
    try {
      final response = await http.get(
        Uri.parse('$url/api/PickList/NomMg?NomMg=$nom'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        List<dynamic> jsondata = jsonDecode(response.body);
        data = jsondata.map((json) => PickList.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      log("$e");
    }
    return data;
  }

Future<List<PickList>> fetchPicklistsByNumLigne(String numLigne) async {
    List<PickList> data = [];
    try {
      final response = await http.get(
        Uri.parse(
            '$url/api/PickList/NumLigne?NumLigne=$numLigne'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        List<dynamic> jsondata = jsonDecode(response.body);
        data =  jsondata.map((json) => PickList.fromJson(json)).toList();
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      log("$e");
      
      return [];
    }
  }

}
