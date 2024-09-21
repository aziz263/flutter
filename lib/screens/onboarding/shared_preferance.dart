import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_screen.dart';

class AuthMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    SharedPreferences.getInstance().then((prefs) {
      String? mail = prefs.getString("mail");
      if (mail != null) {
        return RouteSettings(name: HomePage.name);
      }
    });
    return null;
  }
}
