
import 'package:chasse_marche_app/widgets/BottomNav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'carte.dart';

class CartePage extends StatefulWidget {
  const CartePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CartePage> createState() => _CartePageState();
}

class _CartePageState extends State<CartePage> {
  int _counter = 0;


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Carte(),
        bottomNavigationBar:const BottomNav()
    );
  }
}