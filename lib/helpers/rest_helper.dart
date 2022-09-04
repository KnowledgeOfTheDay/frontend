import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'settings_key.dart';

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
      String? server = Settings.getValue(SettingsKey.server);
      if (null != server && server.isNotEmpty) {
        baseUrl = server;
      }

      HttpOverrides.global = DevHttpOverrides();
    }
  }

  // static Future<bool?> registerDevice() async {
  //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //   final auth = AuthenticationFactory.getOrCreate();
  //   final url = Uri.https(RestHelper.baseUrl, "/api/User");

  //   if (!await auth.loginRequired) {
  //     Map<String, String> headers = {
  //       "content-type": "application/json",
  //     };

  //     final token = await FirebaseMessaging.instance.getToken();
  //     final response = await auth.post(url, body: jsonEncode({"token": token.toString()}), headers: headers);

  //     return response.statusCode == 200;
  //   }

  //   return null;
  // }
}
