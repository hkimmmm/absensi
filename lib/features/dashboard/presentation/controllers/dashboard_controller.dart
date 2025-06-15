import 'package:get/get.dart';
import 'package:smartelearn/features/dashboard/domain/entities/user_info_entity.dart';
import 'package:smartelearn/features/dashboard/domain/repositories/user_repository.dart';
import 'package:smartelearn/features/dashboard/domain/usecase/get_dashboard_data_usecase.dart';

class DashboardController extends GetxController {
  final UserRepository _userRepo;
  final GetDashboardDataUseCase _getUserInfoUseCase;

  final userInfoFromRepo = Rx<UserInfoEntity?>(null);
  final userInfoFromUseCase = Rx<UserInfoEntity?>(null);

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  DashboardController(
    this._userRepo,
    this._getUserInfoUseCase,
  );

  @override
  void onInit() {
    super.onInit();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Pakai _userRepo untuk ambil data
      final userFromRepo = await _userRepo.getDashboardData();
      userInfoFromRepo.value = userFromRepo;

      // Pakai _getUserInfoUseCase untuk ambil data
      final userFromUseCase = await _getUserInfoUseCase();
      userInfoFromUseCase.value = userFromUseCase;
    } catch (e) {
      errorMessage.value = 'Gagal memuat data user: ${e.toString()}';
      Get.snackbar('Error', errorMessage.value);
      userInfoFromRepo.value = null;
      userInfoFromUseCase.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
