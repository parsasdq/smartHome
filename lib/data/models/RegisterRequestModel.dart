class RegisterRequestModel {
  final String username;
  final String email;
  final String password;
  final String? firsName;
  final String? lastname;

  const RegisterRequestModel({
    required this.username,
    required this.email,
    required this.password,
    this.firsName,
    this.lastname,
  });
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'firstname': firsName,
      'lastname': lastname,
    };
  }
}
