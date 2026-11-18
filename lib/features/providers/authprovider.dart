import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_client.dart';
import 'package:smarthome/data/api/authapi.dart';
import 'package:smarthome/data/storage/tokenStorage.dart';
import 'package:smarthome/data/repositories/AuthRepository.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref.read(tokenStorageProvider));
});

final authApiProvider = Provider<Authapi>((ref) {
  return Authapi(ref.read(dioClientProvider).dio);
});

final authProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(authApiProvider),
    ref.read(tokenStorageProvider),
  );
});
