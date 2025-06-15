import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartelearn/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:smartelearn/features/auth/data/repositories/auth_repository_impl.dart'
    as data_impl;
import 'package:smartelearn/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartelearn/features/auth/presentation/controller/auth_controller.dart';
import 'package:smartelearn/features/auth/domain/usecases/login_usecase.dart';
import '../../services/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(Get.find<AuthService>()));
    Get.lazyPut<AuthRepository>(() => data_impl.AuthRepositoryImpl(
          remoteDataSource: Get.find<AuthRemoteDataSource>(),
          prefs: Get.find<SharedPreferences>(),
        ));
    Get.lazyPut<LoginUsecase>(() => LoginUsecase(Get.find<AuthRepository>()));
    Get.lazyPut<AuthController>(
        () => AuthController(loginUseCase: Get.find<LoginUsecase>()));
  }
}
