import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartelearn/features/auth/domain/entities/user_entity.dart';
import 'package:smartelearn/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartelearn/features/auth/data/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences prefs;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.prefs,
  });

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      final user = userModel.toEntity();
      await _saveUserData(user);
      return user;
    } catch (e) {
      throw Exception('Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity?> getLoggedInUser() async {
    final userData = prefs.getString('user_data');
    return userData != null ? _parseUserData(userData) : null;
  }

  @override
  Future<void> logout() async {
    await prefs.remove('user_data');
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  @override
  Future<String?> getToken() async {
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final data = jsonDecode(userData) as Map<String, dynamic>;
      return data['token'] as String?;
    }
    return null;
  }

  // Helper Methods
  Future<void> _saveUserData(UserEntity user) async {
    await prefs.setString(
      'user_data',
      jsonEncode({
        'id': user.id,
        'username': user.username,
        'nama': user.nama,
        'email': user.email,
        'role': user.role,
        'token': user.token,
        'nik': user.nik,
        'foto_profile': user.fotoProfile,
        'no_telepon': user.noTelepon,
        'status': user.status,
        'tanggal_bergabung': user.tanggalBergabung?.toIso8601String(),
      }),
    );
  }

  UserEntity _parseUserData(String userData) {
    final data = jsonDecode(userData) as Map<String, dynamic>;
    return UserEntity(
      id: data['id'] is int
          ? data['id'] as int
          : int.parse(data['id'].toString()),
      username: data['username'] as String,
      nama: data['nama'] as String,
      email: data['email'] as String,
      role: data['role'] as String,
      token: data['token'] as String?,
      nik: data['nik'] as String?,
      fotoProfile: data['foto_profile'] as String?,
      noTelepon: data['no_telepon'] as String?,
      status: data['status'] as String?,
      tanggalBergabung: data['tanggal_bergabung'] != null
          ? DateTime.parse(data['tanggal_bergabung'] as String)
          : null,
    );
  }
}
