import 'package:chasse_marche_app/CartePage.dart';
import 'package:chasse_marche_app/LoginPage.dart';
import 'package:chasse_marche_app/carte.dart';
import 'package:flutter/material.dart';

import 'AccueilPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

