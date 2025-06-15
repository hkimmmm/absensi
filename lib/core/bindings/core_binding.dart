import 'package:get/get.dart';

import 'package:smartelearn/core/network/api_client.dart';

// Tambahkan di salah satu binding yang ada, atau buat CoreBinding
class CoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient());
  }
}
