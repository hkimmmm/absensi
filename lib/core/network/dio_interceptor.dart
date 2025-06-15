import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class DioInterceptor extends Interceptor {
  final Logger _logger = Logger('DioInterceptor');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // You can add token here
    _logger.fine('[REQUEST] => PATH: ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.fine('[RESPONSE] => DATA: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.severe('[ERROR] => MESSAGE: ${err.message}');
    handler.next(err);
  }
}
