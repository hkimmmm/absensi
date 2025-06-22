import 'package:smartelearn/features/dashboard/domain/entities/user_info_entity.dart';
import 'package:smartelearn/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<UserInfoEntity> call() async {
    return await _repository.getProfile();
  }
}
