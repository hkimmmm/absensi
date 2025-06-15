import 'package:smartelearn/services/auth_service.dart';
import 'package:smartelearn/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService authService;

  AuthRemoteDataSourceImpl(this.authService);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await authService.login(email, password);

      if (response['user'] != null) {
        final userJson = response['user'] as Map<String, dynamic>;

        return UserModel.fromJson(userJson);
      } else {
        throw FormatException(
            'Format response tidak sesuai - "user" tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Gagal login: $e');
    }
  }
}
