import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class OfflineInterceptor extends Interceptor {
  final Box _queueBox;
  final Logger _logger;

  OfflineInterceptor(this._queueBox, this._logger);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isNetworkError(err)) {
      _logger.w(
        'OFFLINE: Network error detected. Queueing request: ${err.requestOptions.path}',
      );

      final requestData = {
        'method': err.requestOptions.method,
        'path': err.requestOptions.path,
        'data': err.requestOptions.data,
        'queryParameters': err.requestOptions.queryParameters,
        'headers': err.requestOptions.headers,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _queueBox.add(requestData);

      // Return a custom "Offline" response so the UI doesn't crash
      handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          statusCode: 503,
          statusMessage: 'Offline: Request queued',
          data: {'offline': true, 'message': 'Operación guardada localmente.'},
        ),
      );
    } else {
      handler.next(err);
    }
  }

  bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.error != null && err.error.toString().contains('SocketException'));
  }
}
