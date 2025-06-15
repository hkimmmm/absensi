import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    updateIndexBasedOnRoute(Get.currentRoute);
  }

  void changeIndex(int index) {
    print('Changing index to: $index');
    currentIndex.value = index;
  }

  void updateIndexBasedOnRoute(String route) {
    print('Updating index for route: $route');
    switch (route) {
      case '/dashboard':
        currentIndex.value = 0;
        break;
      case '/leave':
        currentIndex.value = 1;
        break;
      case '/presensi':
        currentIndex.value = 2;
        break;
      case '/profile':
        currentIndex.value = 3;
        break;
      default:
        currentIndex.value = 0; // Default ke Dashboard
    }
  }
}
