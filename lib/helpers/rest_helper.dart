import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:kotd/helpers/authentication_factory.dart';

import '../firebase_options.dart';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class RestHelper {
  static var baseUrl = "kotd.jonascurth.de";

  static void initialize() {
    if (kDebugMode) {
      // baseUrl = "192.168.1.10:59440";
      HttpOverrides.global = DevHttpOverrides();
      print("debug");
    }
  }

  static Future<bool?> registerDevice() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    final auth = AuthenticationFactory.create();
    final url = Uri.https(RestHelper.baseUrl, "/api/User");

    if (!await auth.loginRequired) {
      Map<String, String> headers = {
        "content-type": "application/json",
      };

      final token = await FirebaseMessaging.instance.getToken();
      final response = await auth.post(url, body: jsonEncode({"token": token.toString()}), headers: headers);

      return response.statusCode == 200;
    }

    return null;
  }
}
