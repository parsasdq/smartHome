class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final String username;
  final String name;
  const AuthResponseModel({
    required this.username,
    required this.accessToken,
    required this.refreshToken,
    required this.name,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      name: json["name"] as String,
      username: json["username"] as String,
      accessToken: json['token'] as String,
      refreshToken: json['refToken'] as String,
    );
  }
}
