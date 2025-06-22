import 'package:smartelearn/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:smartelearn/features/dashboard/domain/entities/user_info_entity.dart';
import 'package:smartelearn/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserInfoEntity> getProfile() async {
    try {
      final profileModel = await _remoteDataSource.getProfile();
      return profileModel.toEntity();
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  @override
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      return await _remoteDataSource.updateProfile(data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
