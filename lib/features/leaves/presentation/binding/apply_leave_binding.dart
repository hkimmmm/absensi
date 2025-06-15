// // features/leaves/presentation/binding/apply_leave_binding.dart
// import 'package:get/get.dart';
// import 'package:smartelearn/features/leaves/domain/controllers/apply_leave_controller.dart';
// import 'package:smartelearn/features/leaves/domain/repositories/leave_repository.dart';

// class ApplyLeaveBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<LeaveRepository>(() => LeaveRepository());
//     Get.lazyPut<ApplyLeaveController>(
//       () => ApplyLeaveController(Get.find<LeaveRepository>()),
//     );
//   }
// }
