import 'package:get/get.dart';
import 'package:smartelearn/features/navigation/controller/bottom_nav_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavController());
  }
}
