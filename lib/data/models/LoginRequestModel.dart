class LoginRequestModel {
  final String emailOrUserName;
  final String password;

  const LoginRequestModel({
    required this.emailOrUserName,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'userNameEmail': emailOrUserName, 'password': password};
  }
}
