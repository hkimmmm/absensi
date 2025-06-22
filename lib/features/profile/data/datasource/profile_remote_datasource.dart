import 'package:smartelearn/core/network/api_client.dart';
import 'package:smartelearn/features/dashboard/data/models/user_info_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserInfoModel> getProfile();
  Future<bool> updateProfile(Map<String, dynamic> data);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserInfoModel> getProfile() async {
    final response = await _apiClient.getMap('/profile');
    if (response.containsKey('user') &&
        response['user'] is Map<String, dynamic>) {
      return UserInfoModel.fromJson(response['user']);
    }
    throw Exception('Invalid profile data format');
  }

  @override
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.put('/profile', data: data);
    if (response.containsKey('message') &&
        response['message'] == 'Profil berhasil diperbarui') {
      return true;
    }
    throw Exception('Invalid response format for update profile');
  }
}
