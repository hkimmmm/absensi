import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartelearn/features/profile/presentation/controllers/profile_controller.dart';
import 'package:smartelearn/features/navigation/bottom_nav_bar/custom_bottom_navigation_bar.dart';
import 'profile_detail_page.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu.dart';

// Definisi konstanta warna biar konsisten
const Color primaryColor = Color(0xFF4285F4);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil ProfileController
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Gunakan GetX untuk navigasi
              Get.to(() => const ProfileDetailPage());
            },
          ),
        ],
      ),
      body: Obx(() {
        // Cek status loading dan error
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchProfile,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        // Ambil data user dari profile
        final user = controller.profile.value;
        final nama = user?.nama ?? 'Guest';
        final email = user?.email ?? 'email@contoh.com';
        final fotoProfile = user?.fotoProfile;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Profile Header dengan data dari controller
              ProfileHeader(
                nama: nama,
                email: email,
                fotoProfile: fotoProfile,
              ),
              const SizedBox(height: 20),
              // Profile Menu Items untuk karyawan
              const ProfileMenu(),
            ],
          ),
        );
      }),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
