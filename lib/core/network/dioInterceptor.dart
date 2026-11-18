import 'package:dio/dio.dart';

import 'package:smarthome/data/models/AuthResponsemodel.dart';
import 'package:smarthome/data/storage/tokenStorage.dart';

class DioInterceptor extends Interceptor {
  final Dio _dio;
  final Dio _refreshDio;
  final TokenStorage _tokenStorage;

  // Shared refresh request for concurrent 401 responses
  Future<String?>? _refreshFuture;

  DioInterceptor({required Dio dio, required TokenStorage tokenStorage})
    : _dio = dio,
      _tokenStorage = tokenStorage,
      _refreshDio = Dio(
        BaseOptions(
          baseUrl: dio.options.baseUrl,
          connectTimeout: dio.options.connectTimeout,
          receiveTimeout: dio.options.receiveTimeout,
          sendTimeout: dio.options.sendTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  // 1. Before sending request
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] == true) {
      return handler.next(options);
    }

    try {
      final accessToken = await _tokenStorage.getAccessToken();

      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    } catch (e) {
      handler.reject(DioException(requestOptions: options, error: e));
    }
  }

  // 2. After successful response
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  // 3. Handle request errors
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;

    // Only handle 401 responses
    if (err.response?.statusCode != 401 ||
        request.extra['skipAuth'] == true ||
        request.extra['retry'] == true) {
      return handler.next(err);
    }

    try {
      final failedToken = request.headers['Authorization']?.toString();

      final newAccessToken = await _getFreshAccessToken(failedToken);

      if (newAccessToken == null) {
        return handler.next(err);
      }

      // Retry original request
      request.headers['Authorization'] = 'Bearer $newAccessToken';
      request.extra['retry'] = true;

      final response = await _dio.fetch(request);

      return handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }

  // 4. Get a fresh Access Token
  Future<String?> _getFreshAccessToken(String? failedToken) async {
    if (_refreshFuture != null) {
      return _refreshFuture;
    }

    _refreshFuture = _performRefresh(failedToken);

    try {
      return await _refreshFuture;
    } finally {
      _refreshFuture = null;
    }
  }

  // 5. Perform refresh request
  Future<String?> _performRefresh(String? failedToken) async {
    try {
      final currentAccessToken = await _tokenStorage.getAccessToken();

      // Another request may already have refreshed the token.
      if (currentAccessToken != null &&
          currentAccessToken.isNotEmpty &&
          failedToken != null &&
          failedToken != 'Bearer $currentAccessToken') {
        return currentAccessToken;
      }

      final refreshToken = await _tokenStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        await _tokenStorage.clearTokens();
        return null;
      }

      final response = await _refreshDio.post(
        'Auth/Refresh',
        data: {'refreshToken': refreshToken},
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      await _tokenStorage.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );

      return authResponse.accessToken;
    } catch (e) {
      await _tokenStorage.clearTokens();
      return null;
    }
  }
}
