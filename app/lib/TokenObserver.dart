import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenObserver extends NavigatorObserver {
  final FlutterSecureStorage storage;

  TokenObserver({required this.storage});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _checkToken();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _checkToken();
  }

  Future<void> _checkToken() async {
    String? token = await storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) {
      print('No JWT token found');
    } else {
      print('JWT token found: $token');
    }
  }
}
