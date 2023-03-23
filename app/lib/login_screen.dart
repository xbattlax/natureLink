import 'package:chasse_marche_app/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'models/user.dart';

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

  checkIfUserIsLoggedIn() async {
    isUserLoggedIn = false;
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
  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {

      /// 1) case where user does not exists => return error message
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }

      /// 2) case where password is wrong => return error message
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }

      /// 3) case where login data is OK => returns null
      return null;
    });
  }

  /// Function that creates an account for the new user
  ///
  /// 1) if user has not been created => returns error message 'An error has occured'
  /// 2) if user has been created => returns null
  Future<String?> _signupUser(SignupData data) {
    bool userHasBeenCreated = true;

    /// 1) case where an error occured and the user can not be created
    if(userHasBeenCreated == false){
      return Future.value("An error has occured");
    }

    /// 2) case where user has been created => returns null
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    debugPrint('All additional Data: ${data.additionalSignupData}');
    debugPrint('phone: ${data.additionalSignupData!['phone']}');
    return Future.delayed(loginTime).then((_) {
      setState(() {
        user = User(
          email: data.name!,
          address: data.additionalSignupData!['address']!,
          birthDate: data.additionalSignupData!['birthDay']!,
          firstName: data.additionalSignupData!['firstName']!,
          phone: data.additionalSignupData!['phone']!,
          surname: data.additionalSignupData!['surname']!,
          pseudo: data.additionalSignupData!['pseudo']!,
        );
      });
      return null;
    });
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
