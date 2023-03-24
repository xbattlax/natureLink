import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CartePage.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {


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
      body: Column(
        children: <Widget>[
          Text(
            'Bonjour bienvenu sur l\'application de la chasse et marche',
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CartePage(title: 'Carte');
              }));
            },
            child: const Text('Carte'),
          ),

        ],
      ),
    );
  }
}