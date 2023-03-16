// user_page.dart
import 'dart:convert';
import 'widgets/BottomNav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<void> logout(BuildContext context) async {
  final storage = FlutterSecureStorage();
  await storage.delete(key: 'jwt_token');

  // Rediriger vers la page de connexion
  Navigator.pushReplacementNamed(context, '/login');
}

class User {
  final int id;
  final String email;
  final List<String> roles;

  User({required this.id, required this.email, required this.roles});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      roles: List<String>.from(json['roles']),
    );
  }
}

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<User> getUser() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('http://localhost:8000/api/current_user'),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Page')),
      body: FutureBuilder<User>(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${snapshot.data!.id}'),
                  Text('Email: ${snapshot.data!.email}'),
                  Text('Roles: ${snapshot.data!.roles.join(', ')}'),

                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => logout(context),
                    child: Text('Déconnexion'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
