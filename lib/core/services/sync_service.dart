import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class SyncService {
  final Dio _dio;
  final Box _queueBox;
  final Logger _logger;
  bool _isSyncing = false;

  SyncService(this._dio, this._queueBox, this._logger);

  Future<void> syncPendingRequests() async {
    if (_isSyncing || _queueBox.isEmpty) return;
    _isSyncing = true;

    _logger.i(
      'SYNC: Starting synchronization of ${_queueBox.length} requests...',
    );

    final keys = _queueBox.keys.toList();
    for (final key in keys) {
      final request = _queueBox.get(key);
      if (request == null) continue; // Safety check

      try {
        await _dio.request(
          request['path'],
          data: request['data'],
          queryParameters: request['queryParameters'],
          options: Options(
            method: request['method'],
            headers: request['headers'],
          ),
        );
        await _queueBox.delete(key);
        _logger.i('SYNC: Request ${request['path']} succeeded.');
      } catch (e) {
        _logger.e('SYNC: Failed to replay request ${request['path']}: $e');

        if (e is DioException) {
          final status = e.response?.statusCode ?? 0;
          // 4xx errors are client errors (bad request, auth), so we shouldn't retry them indefinitely
          if (status >= 400 && status < 500) {
            await _queueBox.delete(key);
          }
        }
      }
    }

    _isSyncing = false;
    _logger.i('SYNC: Synchronization complete.');
  }
}
