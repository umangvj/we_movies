import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_movies/core/injection_container.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final prefs = getIt<SharedPreferences>();
    final accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      options.headers.addAll({
        'accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      });
    } else {
      options.headers.addAll({
        'accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      });
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    super.onError(err, handler);
  }
}
