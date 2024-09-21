import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sagem/models/detailpicklist.dart';
import 'package:sagem/models/unite_de_stock.dart';
import 'package:sagem/models/usservie.dart';

import '../../constants.dart';
import '../../models/article.dart';
import '../../models/detailpicklistadd.dart';
import '../../models/picklist.dart';

class ApiHandler {
  Future<void> updatePicklistStatue(int id) async {
    await http.put(
      Uri.parse("$url/api/PickList/Id_PickList?PickListId=$id"),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8'
      },
      body: json.encode({'idSt': 1}),
    );
  }

  Future<http.Response> addDetailPickList({
    required DetailPickListadd detailpicklist,
    required int idPickList,
    required int idArticle,
    required int idSt,
  }) async {
    final uri = Uri.parse(
        "$url/api/DetailPickList?Id_PickList=$idPickList&IdArticle=$idArticle&Id_St=$idSt");

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode(detailpicklist),
      );
      return response;
    } catch (e) {
      return http.Response('Failed to add DetailPickList', 500);
    }
  }

  Future<List<Article>> getArticlesData() async {
    List<Article> data;
    final uri = Uri.parse("$url/api/Article");
    try {
      final response = await http.get(uri);
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        data = jsonData.map((json) => Article.fromJson(json)).toList();
        return data;
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Article> getArticleByArticleData(String articleData) async {
    List<Article> data;
    final uri =
        Uri.parse("$url/api/Article/GetByNomArticle?articledata=$articleData");
    try {
      final response = await http.get(uri);
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        data = jsonData.map((json) => Article.fromJson(json)).toList();
        // Extract article data

        return data.first;
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<PickList>> fetchPicklists() async {
    List<PickList> data = [];
    try {
      final response = await http.get(
        Uri.parse('$url/api/PickList'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        List<dynamic> jsondata = jsonDecode(response.body);

        data = jsondata.map((item) => PickList.fromJson(item)).toList();
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      String h = 'error';
      Get.snackbar(
        h,
        'Error fetching picklists: $e',
        titleText: Text(h, style: const TextStyle(color: Colors.white)),
      );
    }
    return data;
  }

  Future<UniteDeStock> fetchUniteDeStock(String us) async {
    List<UniteDeStock> data = [];
    try {
      final response = await http.get(
        Uri.parse("$url/api/Unité_De_Stock/Us?Us=$us"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        List<dynamic> jsondata = jsonDecode(response.body);
        data = jsondata.map((item) => UniteDeStock.fromJson(item)).toList();
        return data.first;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      log('$e');
    }
    return data.first;
  }

  Future<String> servirDetail(DetailPicklist dpl, String us) async {
    UniteDeStock unite = await fetchUniteDeStock(us);

    var served = await quantiteServi(dpl.idDetailPickList);

    try {
      if (dpl.codeSt == "etat transitoire" && served - dpl.quantite >= 0) {
        final response = await http.put(
          Uri.parse(
              "$url/api/DetailPickList/UpdateDetailPickList?DetailPickListId=${dpl.idDetailPickList}"),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: json.encode({'idSt': 2}),
        );
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          return "success";
        } else {
          return "fail";
        }
      } else if (dpl.codeSt == "demandé" && unite.quantite - dpl.quantite > 0) {
        final response = await http.put(
          Uri.parse(
              "$url/api/DetailPickList/UpdateDetailPickList?DetailPickListId=${dpl.idDetailPickList}"),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: json.encode({'idSt': 2}),
        );
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          return "success";
        } else {
          return "fail";
        }
      } else {
        final response = await http.put(
          Uri.parse(
              "$url/api/DetailPickList/UpdateDetailPickList?DetailPickListId=${dpl.idDetailPickList}"),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: json.encode({'idSt': 3}),
        );
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          return "success";
        } else {
          return "fail";
        }
      }
    } catch (e) {
      return "fail1";
    }
  }

  Future<String> servirAllDetail(String us) async {
    UniteDeStock unite = await fetchUniteDeStock(us);
    List<DetailPicklist> dplList = await fetchByArticle(unite.article);
    List<DetailPicklist> details =
        (dplList.where((detailPicklist) => detailPicklist.codeSt == "demandé"))
            .toList();
    final idDpl = details.first.idDetailPickList;
    final quantite = details.first.quantite;
    final codeSt = details.first.codeSt;

    var served = await quantiteServi(idDpl);

    try {
      if (codeSt == "etat transitoire" && served - quantite >= 0) {
        final response = await http.put(
          Uri.parse(
              "$url/api/DetailPickList/UpdateDetailPickList?DetailPickListId=$idDpl"),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: json.encode({'idSt': 2}),
        );
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          return "success";
        } else {
          return "fail";
        }
      } else if (codeSt == "demandé" && unite.quantite - quantite > 0) {
        final response = await http.put(
          Uri.parse(
              "$url/api/DetailPickList/UpdateDetailPickList?DetailPickListId=$idDpl"),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: json.encode({'idSt': 2}),
        );
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          return "success";
        } else {
          return "fail";
        }
      } else {
        final response = await http.put(
          Uri.parse(
              "$url/api/DetailPickList/UpdateDetailPickList?DetailPickListId=$idDpl"),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: json.encode({'idSt': 3}),
        );
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          return "success";
        } else {
          return "fail";
        }
      }
    } catch (e) {
      return "fail1";
    }
  }

  Future<List<DetailPicklist>> fetchDetails(int id) async {
    List<DetailPicklist> data = [];
    final response = await http.get(
      Uri.parse(
        '$url/api/DetailPickList/Id_PickList?id=$id',
      ),
    );
    if (response.statusCode >= 200 && response.statusCode <= 399) {
      List<dynamic> jsondata = jsonDecode(response.body);
      data = jsondata.map((item) => DetailPicklist.fromJson(item)).toList();
      return data;
    } else {
      return data;
    }
  }

  Future<List<UsServie>> fetchUsServisByDetail(int id) async {
    List<UsServie> data = [];
    final response = await http.get(
      Uri.parse(
        '$url/api/UsServi/IdDetail?id=$id',
      ),
    );
    if (response.statusCode >= 200 && response.statusCode <= 399) {
      List<dynamic> jsondata = jsonDecode(response.body);
      data = jsondata.map((item) => UsServie.fromJson(item)).toList();
      return data;
    } else {
      return data;
    }
  }

  Future<int> quantiteServi(int id) async {
    var quantite = 0;
    List<UsServie> usServie = await fetchUsServisByDetail(id);
    for (UsServie item in usServie) {
      quantite = quantite + item.quantite;
    }
    return quantite;
  }

  Future<String> servirDetailByIdPicklist(int idPicklist, String us) async {
    UniteDeStock unite = await fetchUniteDeStock(us);
    List<DetailPicklist> dpls = await fetchDetails(idPicklist);
    late int idDpl;
    late int quantite;
    late String codeSt;

    for (DetailPicklist item in dpls) {
      if (item.article == unite.article &&
          (item.codeSt == "demandé" || item.codeSt == "etat transitoire")) {
        idDpl = item.idDetailPickList;
        quantite = item.quantite;
        codeSt = item.codeSt;
        break;
      } else {
        idDpl = 0;
        quantite = 0;
        codeSt = "";
      }
    }
    var served = await quantiteServi(idDpl);

    try {
      if (codeSt == "etat transitoire" && served - quantite >= 0) {
        final response = await http.put(
          Uri.parse(
              "$url/api/DetailPickList/UpdateDetailPickList?DetailPickListId=$idDpl"),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: json.encode({'idSt': 2}),
        );
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          return "success";
        } else {
          return "fail";
        }
      } else if (codeSt == "demandé" && unite.quantite - quantite > 0) {
        final response = await http.put(
          Uri.parse(
              "$url/api/DetailPickList/UpdateDetailPickList?DetailPickListId=$idDpl"),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: json.encode({'idSt': 2}),
        );
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          return "success";
        } else {
          return "fail";
        }
      } else {
        final response = await http.put(
          Uri.parse(
              "$url/api/DetailPickList/UpdateDetailPickList?DetailPickListId=$idDpl"),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: json.encode({'idSt': 3}),
        );
        if (response.statusCode >= 200 && response.statusCode <= 399) {
          return "success";
        } else {
          return "fail";
        }
      }
    } catch (e) {
      return "fail1";
    }
  }

  Future<http.Response> addUsServie(
      int idMagasinier, int idUs, int idDetail) async {
    final DateTime dateNow = DateTime.now();
    try {
      final response = await http.post(
        Uri.parse(
            "$url/api/UsServi?Id_Magasinier=$idMagasinier&Id_US=$idUs&Id_DetailPickList=$idDetail"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode({
          "date":
              DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(dateNow.toUtc())
        }),
      );
      return response;
    } catch (e) {
      return http.Response('Failed to add UsServie', 500);
    }
  }

  Future<http.Response> addMouvement(
      int idMagasinier, int idUs, int idDetail) async {
    try {
      final response = await http.post(
        Uri.parse(
            "$url/api/Mouvement?idmg=$idMagasinier&idDetPicklist=$idDetail&idus=$idUs"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode({}),
      );
      return response;
    } catch (e) {
      return http.Response('Failed to add Mouvement', 500);
    }
  }

  Future<List<DetailPicklist>> getemplacement() async {
    List<DetailPicklist> data = [];

    final uri = Uri.parse("$url/api/DetailPicklist");
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => DetailPicklist.fromJson(json)).toList();
      }
    } catch (e) {
      return data;
    }
    return data;
  }

  Future<List<DetailPicklist>> fetchByemplacement(String nom) async {
    List<DetailPicklist> data = [];
    try {
      final response = await http.get(
        Uri.parse('$url/api/DetailPickList/Emplacement?Emplacement=$nom'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        List<dynamic> jsondata = jsonDecode(response.body);
        data = jsondata.map((json) => DetailPicklist.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      log("$e");
    }
    return data;
  }

  Future<List<DetailPicklist>> fetchByArticle(String nomArticle) async {
    List<DetailPicklist> data = [];
    Article article = await getArticleByArticleData(nomArticle);
    int? idArticle = article.idArticle;
    try {
      final response = await http.get(
        Uri.parse('$url/api/DetailPickList/IdArticle?id=$idArticle'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        List<dynamic> jsondata = jsonDecode(response.body);
        data = jsondata.map((json) => DetailPicklist.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      log("$e");
    }
    return data;
  }
}
