import 'dart:convert';

import 'package:smartelearn/config/app_routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartelearn/features/auth/domain/usecases/login_usecase.dart';
import 'package:smartelearn/features/auth/domain/entities/user_entity.dart';
import 'package:smartelearn/features/auth/data/models/user_model.dart';
import 'package:smartelearn/services/auth_service.dart';
// import 'package:smartelearn/features/leaves/data/models/leave_model.dart';

class AuthController extends GetxController {
  final LoginUsecase loginUseCase;
  final AuthService authService = Get.find<AuthService>();

  AuthController({required this.loginUseCase});

  var isLoading = false.obs;
  var user = Rxn<UserEntity>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserFromPrefs();
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = prefs.getString('user_data');
    if (userJsonString != null) {
      try {
        final userModel = UserModel.fromJson(json.decode(userJsonString));
        user.value = userModel.toEntity();
      } catch (e) {
        await logout();
      }
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await loginUseCase(email, password);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        user.value = null;
      },
      (data) async {
        user.value = data;
        final prefs = await SharedPreferences.getInstance();

        final userModel = UserModel(
          userId: data.id,
          username: data.username,
          nama: data.nama,
          email: data.email,
          role: data.role,
          nik: data.nik,
          fotoProfile: data.fotoProfile,
          noTelepon: data.noTelepon,
          status: data.status,
          tanggalBergabung: data.tanggalBergabung,
          token: data.token,
          // leaveRequests: data.leaveRequests
          //     ?.map((leave) => LeaveModel.fromEntity(leave))
          //     .toList()
          //     .cast<LeaveModel>(),
        );

        await prefs.setString('user_data', json.encode(userModel.toJson()));
      },
    );

    isLoading.value = false;
  }

  Future<void> logout() async {
    user.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await authService.clearAuthData(); // Hapus token dan user_id
    Get.offAllNamed(AppRoutes.login); // Arahkan ke login
  }

  // Fungsi untuk memeriksa status login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_data') != null &&
        prefs.getString('auth_token') != null;
  }
}
