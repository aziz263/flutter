import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class Notif{
  final messaging = FirebaseMessaging.instance;
Future<void> sendNotification(String token, String titre, String corps) async {
    const String url = 'https://fcm.googleapis.com/fcm/send';
    //! to change in the new project
    const String serveurKey =
        'AAAAsWPxneo:APA91bEldMK80CCWz-pzRHvLLYSM5-Glloe5mTDByKFx_XIYBEfiLYyMmWQ9jNqO1hvzar7eRNqQqJO3B24hm6q5OWVmZCEQhfByU5cAuMEdAHLJPUT9R_zesYRcIWgeXno0rrPRJ1mN';
    final Map<String, String> entetes = {'Content-Type': 'application/json', 'Authorization': 'key=$serveurKey'};

    final Map<String, dynamic> corpsRequete = {
      'to': token,
      'notification': {'title': titre, 'body': corps, 'mutable_content': true, 'sound': 'Tri-tone'},
    };

    final http.Response reponse = await http.post(
      Uri.parse(url),
      headers: entetes,
      body: jsonEncode(corpsRequete),
    );

    if (reponse.statusCode == 200) {
      log('Notification envoyée avec succès');
    } else {
      log('Échec de lenvoi de la notification. Code de statut : ${reponse.statusCode}');
    }
  }
Future<String> getDeviceToken() async {
    String? token = await messaging.getToken(

    );
    return token ?? '';
  }
Future<void> requestNotificationPermissions() async {
  
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      'User granted permission';
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      'User granted provisional permission';
    } else {
      'User declined or has not accepted permission';
    }
  }
}