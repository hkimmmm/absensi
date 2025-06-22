import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartelearn/features/dashboard/domain/entities/user_info_entity.dart';
import 'package:smartelearn/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:smartelearn/features/profile/domain/usecase/update_profile_usecase.dart';
import 'dart:convert';

class ProfileController extends GetxController {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileController(this._getProfileUseCase, this._updateProfileUseCase);

  final profile = Rx<UserInfoEntity?>(null);
  final isLoading = RxBool(false);
  final errorMessage = RxString('');

  final email = RxString('');
  final nama = RxString('');
  final noTelp = RxString('');
  final alamat = RxString('');
  final fotoProfile = RxString('');

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final userProfile = await _getProfileUseCase();
      profile.value = userProfile;
      email.value = userProfile.email;
      nama.value = userProfile.nama;
      noTelp.value = userProfile.noTelp;
      alamat.value = userProfile.alamat;
      fotoProfile.value = userProfile.fotoProfile;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (email.value.isEmpty || nama.value.isEmpty) {
      errorMessage.value = 'Email dan nama wajib diisi';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = {
        if (email.value.isNotEmpty) 'email': email.value,
        if (nama.value.isNotEmpty) 'nama': nama.value,
        if (noTelp.value.isNotEmpty) 'no_telepon': noTelp.value,
        if (alamat.value.isNotEmpty) 'alamat': alamat.value,
        if (fotoProfile.value.isNotEmpty) 'foto_profile': fotoProfile.value,
      };

      final success = await _updateProfileUseCase(data);
      if (success) {
        await fetchProfile(); // Refresh profil setelah update
        Get.snackbar('Sukses', 'Profil berhasil diperbarui');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        final bytes = await pickedFile.readAsBytes();
        final base64Image = base64Encode(bytes);
        fotoProfile.value = 'data:image/jpeg;base64,$base64Image';
      } catch (e) {
        errorMessage.value = 'Gagal memilih gambar: $e';
        Get.snackbar('Error', errorMessage.value);
      }
    }
  }
}
