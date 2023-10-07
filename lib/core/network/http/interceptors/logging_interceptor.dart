import 'package:dio/dio.dart';

import 'package:flutter_social/core/di/service_locator.dart';

import 'package:flutter_social/core/log/log.dart';

class LoggingInterceptor extends Interceptor {
  Log get log => getIt<Log>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.console('HTTP REQUEST');
    log.console('==============================');

    log.console(
      '${options.method.toUpperCase()} ${(options.baseUrl) + options.path}',
    );

    log.console('Headers:');
    options.headers.forEach(
      (k, v) => log.console('$k: $v'),
    );

    log.console('Query Parameters:');
    options.queryParameters.forEach(
      (k, v) => log.console('$k: $v'),
    );

    if (options.data != null) {
      log.console('Body: ${options.data}');
    }

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    await log.console('HTTP RESPONSE');
    await log.console('==============================');

    await log.console(
      '${response.statusCode} (${response.statusMessage})'
      '${response.requestOptions.baseUrl + response.requestOptions.path}',
    );

    await log.console('Headers:');
    response.headers.forEach(
      (k, v) => log.console('$k: $v'),
    );

    await log.console('Body: ${response.data}');

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    await log.console(
      'HTTP ERROR',
      type: LogType.error,
    );
    await log.console('==============================', type: LogType.error);

    final request = err.requestOptions;

    if (err.response != null) {
      final response = err.response!;
      await log.console(
        '${err.response!.statusCode} (${err.response!.statusMessage})'
        '${request.baseUrl}${request.path}',
        type: LogType.error,
      );

      await log.console('Body: ${response.data}', type: LogType.error);
    } else {
      await log.console(
        '${err.error} (${err.type})'
        '${request.baseUrl}${request.path}',
        type: LogType.error,
      );
    }

    return super.onError(err, handler);
  }
}
