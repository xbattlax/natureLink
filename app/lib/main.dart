import 'CartePage.dart';

import 'package:chasse_marche_app/LoginPage.dart';
import 'package:chasse_marche_app/carte.dart';

import 'LoginPage.dart';
import 'UserPage.dart';
import 'carte.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'AccueilPage.dart';
import 'TokenObserver.dart';
import 'blog/BlogListPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final storage = FlutterSecureStorage();
    final tokenObserver = TokenObserver(storage: storage);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: CartePage(title:"Carte"),

      //home: BlogListPage(onError: () => _redirectToLoginPage(context)),
      navigatorObservers: [tokenObserver],
      routes: {
        '/user': (context) => UserPage(),
        '/login': (context) => LoginPage(), // Add your LoginPage route here
      },

    );
  }
}


void _redirectToLoginPage(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => LoginPage(),
    ),
  );
}
