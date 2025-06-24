import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:get_storage/get_storage.dart';

class ApiClient {
  final Dio dio;
  final Logger logger = Logger();
  final GetStorage _storage = GetStorage();

  ApiClient()
      : dio = Dio(
          BaseOptions(
            //'http://192.168.1.11:3000/api', milik citra buana
            //'http://192.168.18.9:3000/api', milik citra rumah
            baseUrl: 'http://192.168.18.9:3000/api',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            contentType: 'application/json',
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = _storage.read('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        logger.i('Request: ${options.method} ${options.path}');
        logger.i('Headers: ${options.headers}');

        // Tambahkan logging data di sini
        logger.i('POST data (toJson): ${options.data.toString()}');

        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i('Response: ${response.statusCode}');
        logger.i('Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        logger.e('Error: ${e.message}');
        logger.e('Response: ${e.response?.data}');

        if (e.response?.statusCode == 401) {
          logger.w('Unauthorized access - token may be invalid');
        }

        return handler.next(e);
      },
    ));
  }

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write('auth_token', token);
  }

  // Clear token
  Future<void> clearToken() async {
    await _storage.remove('auth_token');
  }

  // Get token
  String? getToken() {
    return _storage.read('auth_token');
  }

  // POST method (return Map)
  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Invalid response format: expected Map');
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.e('DioError: ${e.message}', error: e);
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Request failed');
      }
      throw Exception('Network error occurred');
    } catch (e) {
      logger.e('Unexpected error: $e', error: e);
      throw Exception('An unexpected error occurred');
    }
  }

  // GET method untuk response JSON objek (Map)
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Invalid response format: expected Map');
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.e('DioError: ${e.message}', error: e);
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Request failed');
      }
      throw Exception('Network error occurred');
    } catch (e) {
      logger.e('Unexpected error: $e', error: e);
      throw Exception('An unexpected error occurred');
    }
  }

  // GET method untuk response JSON array (List)
  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      if (response.data is! List<dynamic>) {
        throw Exception('Invalid response format: expected List');
      }

      return response.data as List<dynamic>;
    } on DioException catch (e) {
      logger.e('DioError: ${e.message}', error: e);
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Request failed');
      }
      throw Exception('Network error occurred');
    } catch (e) {
      logger.e('Unexpected error: $e', error: e);
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> patch(String path, {dynamic data}) async {
    try {
      final response = await dio.patch(
        path,
        data: data,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Invalid response format: expected Map');
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.e('DioError: ${e.message}', error: e);
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Request failed');
      }
      throw Exception('Network error occurred');
    } catch (e) {
      logger.e('Unexpected error: $e', error: e);
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Invalid response format: expected Map');
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      logger.e('DioError: ${e.message}', error: e);
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Request failed');
      }
      throw Exception('Network error occurred');
    } catch (e) {
      logger.e('Unexpected error: $e', error: e);
      throw Exception('An unexpected error occurred');
    }
  }
}
