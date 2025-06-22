import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:smartelearn/core/network/api_client.dart';
import 'package:smartelearn/features/dashboard/data/models/user_info_model.dart';

class ProfileService {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  ProfileService(this._apiClient);

  Future<UserInfoModel?> getProfile() async {
    try {
      _logger.i('Fetching profile data...');
      final response = await _apiClient.getMap('/profile');

      // Periksa apakah respons memiliki data user
      if (response.containsKey('user') &&
          response['user'] is Map<String, dynamic>) {
        final userData = response['user'] as Map<String, dynamic>;
        _logger.i('Profile data received: $userData');
        return UserInfoModel.fromJson(userData);
      } else {
        _logger.e('Invalid profile data format');
        throw Exception('Invalid profile data format');
      }
    } on DioException catch (e) {
      _logger.e('Error fetching profile: ${e.message}', error: e);
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch profile');
    } catch (e) {
      _logger.e('Unexpected error fetching profile: $e', error: e);
      throw Exception('An unexpected error occurred while fetching profile');
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      _logger.i('Updating profile with data: $data');
      final response = await _apiClient.put('/profile', data: data);

      // Periksa apakah pembaruan berhasil
      if (response.containsKey('message') &&
          response['message'] == 'Profil berhasil diperbarui') {
        _logger.i('Profile updated successfully');
        return true;
      } else {
        _logger.e('Invalid response format for update profile');
        throw Exception('Invalid response format for update profile');
      }
    } on DioException catch (e) {
      _logger.e('Error updating profile: ${e.message}', error: e);
      throw Exception(
          e.response?.data['message'] ?? 'Failed to update profile');
    } catch (e) {
      _logger.e('Unexpected error updating profile: $e', error: e);
      throw Exception('An unexpected error occurred while updating profile');
    }
  }
}
