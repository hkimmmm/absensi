import '../entities/user_info_entity.dart';

abstract class UserRepository {
  Future<UserInfoEntity> getDashboardData();
}
