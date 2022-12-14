import 'package:flutter_auth/flutter_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationFactory {
  static FlutterAuth? _instance;
  static FlutterAuth getOrCreate() {
    final instance = _instance ??
        FlutterAuth.initialize(
          "https://auth.curth.dev/realms/kotd",
          "kotd-app",
          "kotd://login-callback",
          "https://auth.curth.dev/realms/kotd",
          const FlutterSecureStorage(),
        );
    return instance;
  }
}
