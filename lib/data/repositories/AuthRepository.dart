import 'package:smarthome/data/api/authapi.dart';
import 'package:smarthome/data/storage/tokenStorage.dart';
import 'package:smarthome/data/models/AuthResponsemodel.dart';
import 'package:smarthome/data/models/LoginRequestModel.dart';
import 'package:smarthome/data/models/RegisterRequestModel.dart';

class AuthRepository {
  final Authapi _authApi;
  final TokenStorage _tokenStorage;

  AuthRepository(this._authApi, this._tokenStorage);

  // Login
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    final response = await _authApi.login(request);

    await _tokenStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );

    return response;
  }

  // Register
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    final response = await _authApi.register(request);

    await _tokenStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );

    return response;
  }

  // Refresh Token
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await _authApi.refreshToken(refreshToken);

    await _tokenStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );

    return response;
  }

  // Logout
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
}
