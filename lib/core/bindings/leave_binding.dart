import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:smartelearn/core/network/api_client.dart';
import 'package:smartelearn/features/leaves/data/datasources/leave_remote_data_source.dart';
import 'package:smartelearn/features/leaves/data/datasources/leave_remote_datasource_impl.dart';
import 'package:smartelearn/features/leaves/data/repositories/leave_repository_impl.dart';
import 'package:smartelearn/features/leaves/domain/repositories/leave_repository.dart';
import 'package:smartelearn/features/leaves/domain/usecases/get_leave.dart';
import 'package:smartelearn/features/leaves/domain/usecases/get_leaves_by_status.dart';
import 'package:smartelearn/features/leaves/domain/usecases/apply_leave.dart';
import 'package:smartelearn/features/leaves/presentation/controllers/leave_controller.dart';
import 'package:smartelearn/services/leave_service.dart';

class LeaveBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan ApiClient (pastikan sesuai implementasi kamu)
    Get.lazyPut<ApiClient>(() => ApiClient());

    // Daftarkan Logger
    Get.lazyPut<Logger>(() => Logger());

    // Daftarkan LeaveService dengan dependency ApiClient dan Logger
    Get.lazyPut<LeaveService>(
      () => LeaveService(
        apiClient: Get.find<ApiClient>(),
        logger: Get.find<Logger>(),
      ),
    );

    // Daftarkan LeaveRemoteDatasourceImpl dengan LeaveService yang sudah terdaftar
    Get.lazyPut<LeaveRemoteDatasource>(
      () => LeaveRemoteDatasourceImpl(
        leaveService: Get.find<LeaveService>(),
      ),
    );

    // Repository
    Get.lazyPut<LeaveRepository>(
      () => LeaveRepositoryImpl(
        remoteDatasource: Get.find<LeaveRemoteDatasource>(),
        leaveService: Get.find<LeaveService>(),
      ),
    );

    // Use cases
    Get.lazyPut<GetLeaves>(() => GetLeaves(Get.find<LeaveRepository>()));
    Get.lazyPut<GetLeavesByStatus>(
        () => GetLeavesByStatus(Get.find<LeaveRepository>()));
    Get.lazyPut<ApplyLeave>(() => ApplyLeave(Get.find<LeaveRepository>()));

    // Controller
    Get.lazyPut<LeaveController>(() => LeaveController(
          getLeaves: Get.find<GetLeaves>(),
          // getLeavesByStatus: Get.find<GetLeavesByStatus>(),
          applyLeave: Get.find<ApplyLeave>(),
        ));
  }
}
