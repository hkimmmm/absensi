import 'package:smartelearn/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Authenticates user with email and password.
  /// Returns [UserEntity] if successful.
  Future<UserEntity> login(String email, String password);

  /// Returns currently logged in user.
  Future<UserEntity?> getLoggedInUser();

  /// Clears user authentication data.
  Future<void> logout();

  /// Checks whether a user is currently logged in.
  Future<bool> isLoggedIn();

  /// Returns the stored auth token if available.
  Future<String?> getToken();
}
