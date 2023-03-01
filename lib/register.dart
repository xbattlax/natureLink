import 'dart:ffi';

import 'package:chasse_marche_app/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  var state = 0;
  var json = {};
  TextEditingController email = TextEditingController();
  var field = ["email","password","confirmpassword", "username","name", "surname", "date de naissance","phone", "address" ];
  Map<String,TextEditingController> _controler = Map<String,TextEditingController>();
  void initState() {
    for (var i in field) {
      _controler.putIfAbsent("${i}", () => TextEditingController());
    }
    super.initState();

  }
  List<Widget> composant(TextEditingController? c, String name){
    return [TextField(
      style: TextStyle(color: Colors.white),
      controller: c,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        hintText: name,
        hintStyle: const TextStyle(color: Colors.white),
      ),
    ),
    const SizedBox(
    height: 30,
    ),
    ];
  }

  List<Widget> form(){
    switch (state) {
      case 0:
        var res = <Widget>[];
        for (var i = 0; i<3; i++) {
          res.addAll(composant(_controler[field[i]], "${field[i]}"));

        }

        return res;
      case 1:
        var res = <Widget>[];
        for (var i = 3; i<6; i++) {
          res.addAll(composant(_controler[field[i]], "${field[i]}"));
        }
        return res;
      case 2:
        var res = <Widget>[];
        for (var i = 6; i<9; i++) {
          res.addAll(composant(_controler[field[i]], "${field[i]}"));
        }
        return res;
      default:
        return [];
  }
  }
  get(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getString(name);
    //bothget();
  }

  set(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(name, _controler[name]!.text);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration: const BoxDecoration(
        //image: DecorationImage(
            //image: AssetImage('assets/images/register.png'), fit: BoxFit.cover),
      //),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 80),
            child: const Text(
              "Create\nAccount",
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  right: 35,
                  left: 35,
                  top: MediaQuery.of(context).size.height * 0.27),
              child: Column(children: [
                ...form(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xff4c505b),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            switch (state) {
                              case 0:
                                for (var i = 0; i<3; i++) {
                                  set(field[i]);
                                }
                                setState(() {
                                  state = 1;
                                });
                                break;
                              case 1:
                                for (var i = 0; i<3; i++) {
                                  set(field[i]);
                                }
                                setState(() {
                                  state = 2;
                                });
                                break;
                              case 2:
                                for (var i = 0; i<3; i++) {
                                  set(field[i]);
                                }
                                setState(() {
                                  json.addAll({
                                    "email": _controler["email"]!.text,
                                    "password": _controler["password"]!.text,
                                    "confirmpassword": _controler["confirmpassword"]!.text,
                                    "username": _controler["username"]!.text,
                                    "name": _controler["name"]!.text,
                                    "surname": _controler["surname"]!.text,
                                    "date de naissance": _controler["date de naissance"]!.text,
                                    "phone": _controler["phone"]!.text,
                                    "address": _controler["address"]!.text,
                                  });
                                  print(json.toString());
                                  state = 0;
                                });
                                break;
                            }
                            },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 40,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }));
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Colors.white,
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
