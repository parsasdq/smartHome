import 'package:dio/dio.dart';
import 'package:smarthome/data/models/AuthResponsemodel.dart';
import 'package:smarthome/data/models/LoginRequestModel.dart';
import 'package:smarthome/data/models/RegisterRequestModel.dart';

class Authapi {
  final Dio _dio;

  Authapi(this._dio);

  // Login
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    final response = await _dio.post(
      'Auth/Login',
      data: request.toJson(),
      options: Options(extra: {'skipAuth': true}),
    );

    return AuthResponseModel.fromJson(response.data);
  }

  // Register
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    final response = await _dio.post(
      'Auth/Register',
      data: request.toJson(),
      options: Options(extra: {'skipAuth': true}),
    );

    return AuthResponseModel.fromJson(response.data);
  }

  // Refresh Token
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      'Auth/Refresh',
      data: {'refreshToken': refreshToken},
    );

    return AuthResponseModel.fromJson(response.data);
  }
}
