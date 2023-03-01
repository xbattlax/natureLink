import 'dart:async';

import 'package:chasse_marche_app/AccueilPage.dart';
import 'package:chasse_marche_app/register.dart';
//import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:chasse_marche_app/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String value;

  void initState() {
    getemail();
    sharedget();

    super.initState();
  }

  TextEditingController email = TextEditingController();

  final password = TextEditingController();

  getemail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getString("Email");
    bothget();
  }

  setemail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("Email", email.text);
  }

  //for password//
  Sharedset() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("Password", password.text);
  }

  sharedget() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getString("Password");
    bothget();
  }

  bothget() {
    if (email.text == "test" && password.text == "") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const AccueilPage(title: 'Home');
      }));
    } else {
      final snack = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Wrong details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      //decoration: const BoxDecoration(
        //image: DecorationImage(
            //image: AssetImage('assets/images/login.png'), fit: BoxFit.cover),
      //),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 80),
            child: const Text(
              "Welcome\nBack",
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  right: 35,
                  left: 35,
                  top: MediaQuery.of(context).size.height * 0.5),
              child: Column(children: [
                TextField(
                  controller: email,
                  decoration: InputDecoration(

                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  obscureText: true,
                  controller: password,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Color(0xff4c505b),
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xff4c505b),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {getemail();
                        sharedget();},
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const MyRegister();
                          }));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Color(0xff4c505b),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Color(0xff4c505b),
                          ),
                        ),
                      ),
                    ]),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}