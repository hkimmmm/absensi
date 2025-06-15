import '../entities/user_info_entity.dart';
import '../repositories/user_repository.dart';

class GetDashboardDataUseCase {
  final UserRepository repository;

  GetDashboardDataUseCase(this.repository);

  Future<UserInfoEntity> call() {
    return repository.getDashboardData();
  }
}
