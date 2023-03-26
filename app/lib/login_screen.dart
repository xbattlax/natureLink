import 'package:chasse_marche_app/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


const users = {
  'test@gmail.com': 'test',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  /// fake duration; used to simulate time used when user tries to login
  Duration get loginTime => const Duration(milliseconds: 750);

  bool isUserLoggedIn = false;
  late User user;

  @override
  void initState() {
    checkIfUserIsLoggedIn();
    super.initState();
  }

  Future<String> authenticate(String email, String password) async {
    final String apiUrl = 'http://localhost:8000/api/login_check';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse['token'];
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<bool> registerUser(Map<String, String> userData) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      // Registration successful
      print('Registration successful');
      return true;
    } else {
      // Registration failed
      print('Registration failed with status code: ${response.statusCode}');
      print('Error: ${response.body}');
      return false;
    }
  }

  checkIfUserIsLoggedIn() async {
    final storage = FlutterSecureStorage();
    String? storedUser = await storage.read(key: 'user');
    if (storedUser != null) {
      setState(() {
        user = User.fromJson(jsonDecode(storedUser));
        isUserLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(isUserLoggedIn){
      return ProfileScreen(user: user,);
    }
    return Scaffold(
      body: FlutterLogin(
        title: 'NATURE LINK',
        logo: const AssetImage('assets/naturelink_logo.png'),
        onLogin: _authUser,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () => _onSubmitAnimationCompleted(context),
        onRecoverPassword: _recoverPassword,
        loginProviders: <LoginProvider>[
          facebookProvider(),
        ],
        messages: LoginMessages(
            userHint: 'Email',
            passwordHint: 'Mot de passe',
            forgotPasswordButton: 'Mot de passe oublié ?',
            loginButton: 'SE CONNECTER',
            signupButton: 'S\'INSCRIRE',
            confirmPasswordHint: 'Répéter mot de passe',
            recoverPasswordButton: 'ENVOYER',
            goBackButton: 'RETOUR',
            recoverPasswordDescription: 'Nous allons vous envoyer les instructions par mail',
            recoverPasswordSuccess: 'Email envoyé !',
            confirmPasswordError: 'Les mots de passe de correspondent pas !',
            providersTitleFirst: 'ou continuer avec',
            signUpSuccess: 'Un lien d\'activation a été envoyé',
            recoverPasswordIntro: 'Réinitialisez votre mot de passe ici',
            additionalSignUpFormDescription: 'Veuillez compléter les informations additionnelles',
          additionalSignUpSubmitButton: 'CONTINUER',
        ),
        theme: LoginTheme(
          primaryColor: Colors.green[900],
        ),
        additionalSignupFields: [
          UserFormField(
            keyName: 'firstName',
            displayName: 'Prénom',
            userType: LoginUserType.name,
            fieldValidator: _fieldValidator,
            icon: Icon(FontAwesomeIcons.userLarge),
          ),
          UserFormField(
            keyName: 'surname',
            displayName: 'Nom de famille',
            userType: LoginUserType.name,
            fieldValidator: _fieldValidator,
            icon: Icon(FontAwesomeIcons.userLarge),
          ),
          UserFormField(
            keyName: 'pseudo',
            displayName: 'Pseudo',
            userType: LoginUserType.name,
            fieldValidator: _fieldValidator,
            icon: Icon(FontAwesomeIcons.at),
          ),
          UserFormField(
            keyName: 'address',
            displayName: 'Adresse',
            userType: LoginUserType.name,
            fieldValidator: _fieldValidator,
            icon: Icon(Icons.place),
          ),
          UserFormField(
            keyName: 'phone',
            displayName: 'Num. de téléphone',
            userType: LoginUserType.phone,
            fieldValidator: _fieldValidator,
            icon: Icon(FontAwesomeIcons.phone),
          ),
          UserFormField(
            keyName: 'birthDay',
            displayName: 'Date de naissance',
            userType: LoginUserType.name,
            fieldValidator: _fieldValidator,
            icon: Icon(Icons.date_range_rounded),
          ),
        ],
      ),
    );
  }

  /// basic validation : checks if field is empty
  /// returns null if not empty
  String? _fieldValidator(String? arg) {
    if(arg != null && arg.isEmpty) {
      return 'Champ obligatoire';
    } else {
      return null;
    }
  }

  LoginProvider facebookProvider(){
    return LoginProvider(
      icon: FontAwesomeIcons.facebookF,
      label: 'Facebook',
      callback: () async {
        debugPrint('start facebook sign in');
        await Future.delayed(loginTime);
        debugPrint('stop facebook sign in');
        return null;
      },
    );
  }

  /// Function that authenticates the user
  ///
  /// 1) if user does not exists => returns error message 'User not exists'
  /// 2) if password is wrong => returns errors message 'Password does not match'
  /// 3) if login data are ok => returns null
  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    final storage = FlutterSecureStorage();
    try {
      String token = await authenticate(data.name!, data.password!);
      print('token: $token');
      // Store jwt_token using FlutterSecureStorage
      final storage = FlutterSecureStorage();
      await storage.write(key: 'jwt_token', value: token);


      final currentUser = await getCurrentUser(token);
      List<dynamic> currentUserRoles = currentUser['roles'];
      List<String> roles = currentUserRoles.cast<String>();
      await storage.write(key: 'roles', value: jsonEncode(roles));

      setState(() { user = User(
        email: currentUser['email'],
        address: currentUser['address'],
        birthDate: currentUser['BirdthDate']??'',
        firstName: currentUser['firstName']??'',
        phone: currentUser['phone'],
        surname: currentUser['surname'],
        pseudo: currentUser['pseudo'],
        roles: roles,
      );
        storage.write(key: 'user', value: jsonEncode(user));
      });
      // Return null to indicate successful authentication
      return null;
    } catch (e) {
      print('Error: $e');
      // Return an error message if authentication fails
      return 'Failed to authenticate';
    }
  }

  /// Function that creates an account for the new user
  ///
  /// 1) if user has not been created => returns error message 'An error has occured'
  /// 2) if user has been created => returns null
  Future<String?> _signupUser(SignupData data) async {
    // Prepare user data
    Map<String, String> userData = {
      'email': data.name!,
      'password': data.password!,
      'address': data.additionalSignupData!['address']!,
      'birthDate': data.additionalSignupData!['birthDay']!,
      'firstName': data.additionalSignupData!['firstName']!,
      'phone': data.additionalSignupData!['phone']!,
      'surname': data.additionalSignupData!['surname']!,
      'pseudo': data.additionalSignupData!['pseudo']!,
    };

    // Call registerUser function
    bool userHasBeenCreated = await registerUser(userData);

    // 1) case where an error occurred and the user cannot be created
    if (!userHasBeenCreated) {
      return "An error has occurred";
    }

    // 2) case where user has been created => returns null
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    debugPrint('All additional Data: ${data.additionalSignupData}');
    debugPrint('phone: ${data.additionalSignupData!['phone']}');
    await Future.delayed(loginTime);
    setState(() {
      user = User(
        email: data.name!,
        address: data.additionalSignupData!['address']!,
        birthDate: data.additionalSignupData!['birthDay']!,
        firstName: data.additionalSignupData!['firstName']!,
        phone: data.additionalSignupData!['phone']!,
        surname: data.additionalSignupData!['surname']!,
        pseudo: data.additionalSignupData!['pseudo']!,
        roles : ['ROLE_USER'],
      );
    });
    return null;
  }

  Future<Map<String, dynamic>> getCurrentUser(String token) async {
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/current_user'),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/ld+json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get current user');
    }
  }

  _onSubmitAnimationCompleted(BuildContext context) {
    setState(() {
      isUserLoggedIn = true;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

}
