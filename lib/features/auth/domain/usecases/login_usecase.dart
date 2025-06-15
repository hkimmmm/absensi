import 'package:dartz/dartz.dart';
import 'package:smartelearn/features/auth/domain/entities/user_entity.dart';
import 'package:smartelearn/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartelearn/core/errors/failures.dart';

/// Use case untuk login user
class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  /// Menjalankan login menggunakan email dan password
  /// Mengembalikan [UserEntity] jika berhasil, atau [Failure] jika gagal
  Future<Either<Failure, UserEntity>> call(
    String email,
    String password,
  ) async {
    try {
      final user = await repository.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
