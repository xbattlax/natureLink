import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bottom_navigation_screen_selection.dart';
import 'login_screen.dart';
import 'models/user.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  /// get a random avatar image from https://xsgames.co/
  /// Since there is only 53 images, we'll choose a random one between those 53 ones
  String generateRandomAvatarImage(){
    int randomNbr = Random().nextInt(53);
    String basePath = "https://xsgames.co/randomusers/assets/avatars/pixel/$randomNbr.jpg";
    return basePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.green[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _buildList(),
    );
  }

  void _logout(BuildContext context) async {
    final storage = FlutterSecureStorage();

    // Clear stored user data
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'user');

    // Navigate back to the LoginScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BottomNavScreenSelection()),
          (Route<dynamic> route) => false,
    );
  }

  Widget _buildList(){
    return ListView(
    children: <Widget>[
      _buildProfileImagePart(),
      _buildEmailListTile(),
      const Divider(),
      _buildPhoneListTile(),
      const Divider(),
      _buildAddressListTile(),
      const Divider(),
      _buildBirthDateListTile(),
      const Divider(),
      _buildFbListTile(),
    ],
    );
  }

  Widget _buildProfileImagePart(){
    return Container(
      //height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2, 0.9],
          colors: [Colors.green[700]!, Colors.teal.shade300],
        ),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: CircleAvatar(
              minRadius: 60,
              backgroundColor: Colors.black87,
              child: CircleAvatar(
                backgroundImage: NetworkImage(generateRandomAvatarImage()),
                minRadius: 50,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _hunterOrNot(),
                Text(
                  "${user.firstName} ${user.surname}",
                  style: const TextStyle(fontSize: 22.0, color: Colors.white),
                ),
                Text(
                  "@${user.pseudo}",
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _hunterOrNot(){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: const EdgeInsets.symmetric( vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(color: Colors.black87)
      ),
      child: Center(
        child: Text(

          getUserRole(user.roles),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,

          ),
        ),
      ),
    );
  }

  String getUserRole(List<dynamic>? roles) {

    if (roles == null) {
      return "PROMENEUR";
    }

    return roles.contains("ROLE_CHASSEUR") ? "CHASSEUR" : "PROMENEUR";
  }

  Widget _buildEmailListTile(){
    return ListTile(
      leading: Icon(Icons.mail),
      title: Text(
        "Email",
        style: TextStyle(color: Colors.green[900], fontSize: 12.0),
      ),
      subtitle: Text(
        user.email,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(Icons.edit),
      onTap: (){
      },
    );
  }

  Widget _buildPhoneListTile(){
    return ListTile(
      leading: Icon(FontAwesomeIcons.phone),
      title: Text(
        "Numéro de téléphone",
        style: TextStyle(color: Colors.green[900], fontSize: 12.0),
      ),
      subtitle: Text(
        user.phone,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(Icons.edit),
      onTap: (){
      },
    );
  }

  Widget _buildAddressListTile(){
    return ListTile(
      leading: Icon(FontAwesomeIcons.locationPin),
      title: Text(
        "Adresse",
        style: TextStyle(color: Colors.green[900], fontSize: 12.0),
      ),
      subtitle: Text(
        user.address,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(Icons.edit),
      onTap: (){
      },
    );
  }

  Widget _buildBirthDateListTile(){
    return ListTile(
      leading: Icon(FontAwesomeIcons.calendar),
      title: Text(
        "Date de naissance",
        style: TextStyle(color: Colors.green[900], fontSize: 12.0),
      ),
      subtitle: Text(
        user.birthDate,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(Icons.edit),
      onTap: (){
      },
    );
  }

  Widget _buildFbListTile(){
    return ListTile(
      leading: Icon(FontAwesomeIcons.facebook),
      title: Text(
        "Facebook",
        style: TextStyle(color: Colors.green[900], fontSize: 12.0),
      ),
      subtitle: Text(
        user.facebookUserName == null ? "Non connecté à Facebook" : "facebook.com/${user.facebookUserName}",
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(Icons.edit),
      onTap: (){
      },
    );
  }
}