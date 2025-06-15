import 'package:get/get.dart';
import 'package:smartelearn/features/dashboard/data/datasources/user_remote_data_source.dart';
import 'package:smartelearn/features/dashboard/data/repositories/user_repository_impl.dart';
import 'package:smartelearn/features/dashboard/domain/repositories/user_repository.dart';
import 'package:smartelearn/features/dashboard/domain/usecase/get_dashboard_data_usecase.dart';
import 'package:smartelearn/features/dashboard/presentation/controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRemoteDataSource>(() => UserRemoteDataSourceImpl());

    Get.lazyPut<UserRepository>(() =>
        UserRepositoryImpl(remoteDataSource: Get.find<UserRemoteDataSource>()));

    Get.lazyPut(() => GetDashboardDataUseCase(Get.find<UserRepository>()));

    Get.lazyPut(() => DashboardController(
          Get.find<UserRepository>(),
          Get.find<GetDashboardDataUseCase>(),
        ));
  }
}
