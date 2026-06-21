import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class PerformanceInterceptor extends Interceptor {
  final Logger logger;

  PerformanceInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now().millisecondsSinceEpoch;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as int?;
    if (startTime != null) {
      final duration = DateTime.now().millisecondsSinceEpoch - startTime;
      logger.i(
        'PERFORMANCE: [${response.requestOptions.method}] ${response.requestOptions.path} took ${duration}ms',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['startTime'] as int?;
    if (startTime != null) {
      final duration = DateTime.now().millisecondsSinceEpoch - startTime;
      logger.w(
        'PERFORMANCE: [${err.requestOptions.method}] ${err.requestOptions.path} failed after ${duration}ms',
      );
    }
    handler.next(err);
  }
}
