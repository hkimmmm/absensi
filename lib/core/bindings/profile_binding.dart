import 'package:get/get.dart';
import 'package:smartelearn/core/network/api_client.dart';
import 'package:smartelearn/features/profile/domain/repositories/profile_repository.dart';
import 'package:smartelearn/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:smartelearn/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:smartelearn/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:smartelearn/features/profile/domain/usecase/update_profile_usecase.dart';
import 'package:smartelearn/features/profile/presentation/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Inisialisasi ApiClient
    Get.lazyPut(() => ApiClient());

    // Inisialisasi DataSource
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(Get.find<ApiClient>()),
    );

    // Inisialisasi Repository
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(Get.find<ProfileRemoteDataSource>()),
    );

    // Inisialisasi UseCase
    Get.lazyPut(() => GetProfileUseCase(Get.find<ProfileRepository>()));
    Get.lazyPut(() => UpdateProfileUseCase(Get.find<ProfileRepository>()));

    // Inisialisasi Controller
    Get.lazyPut(() => ProfileController(
          Get.find<GetProfileUseCase>(),
          Get.find<UpdateProfileUseCase>(),
        ));
  }
}
