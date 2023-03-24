
class User {
  final String pseudo;
  final String firstName;
  final String surname;
  final String email;
  final String phone;
  final String birthDate;
  final String address;
  final bool isHunter;
  final String? facebookUserName;

  User({
    this.pseudo = "",
    this.firstName = "",
    this.surname = "",
    this.email = "",
    this.phone = "",
    this.birthDate = "",
    this.address = "",
    this.isHunter = false,
    this.facebookUserName,
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
      isHunter: json['isHunter'] ?? false,
      facebookUserName: json['facebookUserName'],
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
    'isHunter': isHunter,
    'facebookUserName': facebookUserName,
  };

}