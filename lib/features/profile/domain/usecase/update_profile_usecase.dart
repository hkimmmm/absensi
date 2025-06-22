import 'package:smartelearn/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<bool> call(Map<String, dynamic> data) async {
    return await _repository.updateProfile(data);
  }
}
