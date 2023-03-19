
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
}