import 'package:chasse_marche_app/AccueilPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CartePage.dart';
import '../blog/BlogListPage.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  void initState() {
    getCurrentIndex();
    super.initState();
  }

  getCurrentIndex() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _selectedIndex = pref.getInt("Index")!;
    setState(() {});
  }

  setCurrentIndex() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("Index", _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        setCurrentIndex();
        Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => AccueilPage(title: "Home")));
        break;
      case 1:
        setCurrentIndex();
        Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => CartePage(title: "Carte")));
        break;
      case 2:
        setCurrentIndex();
        Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => BlogListPage()));
        break;
      //case 3:
        //setCurrentIndex();
        //Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => UserInterfacePage(title: "User Interface")));
        //break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
          icon: Icon(Icons.article),
          label: 'Blog',
          backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'User Interface',
          backgroundColor: Colors.green,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}
