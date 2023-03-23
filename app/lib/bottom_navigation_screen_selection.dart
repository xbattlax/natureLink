import 'package:chasse_marche_app/AccueilPage.dart';
import 'package:chasse_marche_app/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CartePage.dart';

class BottomNavScreenSelection extends StatefulWidget {
  const BottomNavScreenSelection({Key? key}) : super(key: key);

  @override
  State<BottomNavScreenSelection> createState() => _BottomNavScreenSelectionState();

}

class _BottomNavScreenSelectionState extends State<BottomNavScreenSelection> {
  int _selectedIndex = 0;
  String sharedPreferenceIndexKey = "Index";
  var pages = [
    const AccueilPage(title: "Home"),
    const CartePage(title: "Carte"),
    const LoginScreen(),
  ];

  @override
  void initState() {
    getCurrentIndex();
    super.initState();
  }

  /// get last index saved in shared preferences
  /// if does not exist, returns 0, so the first tab
  getCurrentIndex() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int lastIndex = pref.getInt(sharedPreferenceIndexKey) ?? 0;
    _selectedIndex = lastIndex;
    /*setState(() {
      _selectedIndex = lastIndex;
    });*/
  }

  setCurrentIndex() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(sharedPreferenceIndexKey, _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print("_select = $_selectedIndex");
    print("index = $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Carte',
            backgroundColor: Colors.pink,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profil',
            backgroundColor: Colors.blue,
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}