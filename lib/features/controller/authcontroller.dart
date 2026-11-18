import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smarthome/data/models/AuthResponsemodel.dart';
import 'package:smarthome/data/models/LoginRequestModel.dart';
import 'package:smarthome/data/models/RegisterRequestModel.dart';
import 'package:smarthome/data/repositories/AuthRepository.dart';
import 'package:smarthome/features/providers/authprovider.dart';

class AuthController extends AsyncNotifier<void> {
  late final AuthRepository _authRepository;

  @override
  Future<void> build() async {
    _authRepository = ref.read(authProvider);
  }

  Future<AuthResponseModel> login(LoginRequestModel request) async {
    state = const AsyncLoading();

    try {
      final response = await _authRepository.login(request);

      state = const AsyncData(null);

      return response;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    state = const AsyncLoading();

    try {
      final response = await _authRepository.register(request);

      state = const AsyncData(null);

      return response;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      await _authRepository.logout();

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);
