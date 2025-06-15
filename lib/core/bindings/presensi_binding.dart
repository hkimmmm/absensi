import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:smartelearn/core/network/api_client.dart';
import 'package:smartelearn/services/presensi_service.dart';

import 'package:smartelearn/features/presensi/data/datasources/presensi_remote_datasource.dart';
import 'package:smartelearn/features/presensi/data/repositories/presensi_repository_impl.dart';
import 'package:smartelearn/features/presensi/domain/repositories/presensi_repository.dart';

import 'package:smartelearn/features/presensi/domain/usecases/checkin_usecase.dart';
import 'package:smartelearn/features/presensi/domain/usecases/checkout_usecase.dart';
import 'package:smartelearn/features/presensi/domain/usecases/get_data_usecase.dart';

import 'package:smartelearn/features/presensi/presentation/controllers/presensi_controller.dart';

class PresensiBinding extends Bindings {
  @override
  void dependencies() {
    // ApiClient
    Get.lazyPut<ApiClient>(() => ApiClient());

    // Logger
    Get.lazyPut<Logger>(() => Logger());

    // PresensiService
    Get.lazyPut<PresensiService>(() => PresensiService(
          apiClient: Get.find<ApiClient>(),
          logger: Get.find<Logger>(),
        ));

    // Remote Datasource
    Get.lazyPut<PresensiRemoteDatasource>(() => PresensiRemoteDatasourceImpl(
          service: Get.find<PresensiService>(),
        ));

    // Repository
    Get.lazyPut<PresensiRepository>(() => PresensiRepositoryImpl(
          Get.find<PresensiRemoteDatasource>(),
        ));

    // Usecases
    Get.lazyPut<CheckInUseCase>(() => CheckInUseCase(Get.find()));
    Get.lazyPut<CheckOutUseCase>(() => CheckOutUseCase(Get.find()));
    Get.lazyPut<GetDataUseCase>(() => GetDataUseCase(Get.find()));

    // Controller
    Get.lazyPut<PresensiController>(() => PresensiController(
          checkInUseCase: Get.find(),
          checkOutUseCase: Get.find(),
          getDataUseCase: Get.find(),
        ));
  }
}
