import 'package:dio/dio.dart';

import 'dioInterceptor.dart';
import 'package:smarthome/data/storage/tokenStorage.dart';

class DioClient {
  late final Dio dio;

  DioClient(TokenStorage tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://localhost:7224/api/',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(DioInterceptor(dio: dio, tokenStorage: tokenStorage));
  }
}
