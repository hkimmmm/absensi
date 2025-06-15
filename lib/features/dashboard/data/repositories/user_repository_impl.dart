import 'package:smartelearn/features/dashboard/domain/entities/user_info_entity.dart';
import 'package:smartelearn/features/dashboard/domain/repositories/user_repository.dart';
import 'package:smartelearn/features/dashboard/data/datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserInfoEntity> getDashboardData() async {
    return await remoteDataSource.getDashboardData();
  }
}
