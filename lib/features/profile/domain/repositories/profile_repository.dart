import 'package:smartelearn/features/dashboard/domain/entities/user_info_entity.dart';

abstract class ProfileRepository {
  Future<UserInfoEntity> getProfile();
  Future<bool> updateProfile(Map<String, dynamic> data);
}
