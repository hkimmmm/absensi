import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:smartelearn/core/network/api_client.dart';

class DashboardServices {
  final ApiClient apiClient = ApiClient();
  final Logger _logger = Logger();

  Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      final response = await apiClient.getMap('/dashboard');
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
}
