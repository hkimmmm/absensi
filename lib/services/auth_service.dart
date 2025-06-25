import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:smartelearn/core/network/api_client.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient apiClient = ApiClient();
  final Logger _logger = Logger();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await apiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.containsKey('token')) {
        await apiClient.saveToken(response['token']);
      }

      // Simpan user_id (misalnya dari response['user']['id'] atau response['user_id'])
      if (response.containsKey('user_id')) {
        final storage = GetStorage();
        await storage.write('user_id', response['user_id']);
      }

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        _logger.e('Error status: ${e.response?.statusCode}');
        _logger.e('Error data: ${e.response?.data}');
        return e.response?.data ?? {'error': 'Unknown error occurred'};
      } else {
        _logger.e('Dio error: ${e.message}');
        throw Exception(e.message);
      }
    }
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await apiClient.clearToken(); // Pastikan ApiClient memiliki fungsi ini
  }
}
