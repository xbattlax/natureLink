
class User {
  final String pseudo;
  final String firstName;
  final String surname;
  final String email;
  final String phone;
  final String birthDate;
  final String address;
  final String? facebookUserName;
  final List<dynamic> roles;

  User({
    this.pseudo = "",
    this.firstName = "",
    this.surname = "",
    this.email = "",
    this.phone = "",
    this.birthDate = "",
    this.address = "",
    this.facebookUserName,
    this.roles= const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      pseudo: json['pseudo'] ?? '',
      firstName: json['firstName'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      birthDate: json['birthDate'] ?? '',
      address: json['address'] ?? '',
      facebookUserName: json['facebookUserName'],
      roles: json['roles'],
    );
  }



  Map<String, dynamic> toJson() => {
    'pseudo': pseudo,
    'firstName': firstName,
    'surname': surname,
    'email': email,
    'phone': phone,
    'birthDate': birthDate,
    'address': address,
    'facebookUserName': facebookUserName,
    'roles': roles,
  };

}