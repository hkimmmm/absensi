import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smartelearn/core/network/api_client.dart';
import 'package:smartelearn/features/profile/presentation/controllers/profile_controller.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4285F4),
        elevation: 0,
      ),
      body: Obx(() {
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

        final user = controller.profile.value;
        final nama = user?.nama ?? 'Guest';
        final email = user?.email ?? 'email@contoh.com';
        final noTelp = user?.noTelp ?? '';
        final alamat = user?.alamat ?? '';
        final fotoProfile = user?.fotoProfile;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Foto Profil
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: _buildProfileAvatar(fotoProfile),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: controller.pickImage,
                  child: const Text(
                    'Pilih Foto Profil',
                    style: TextStyle(color: Color(0xFF4285F4)),
                  ),
                ),
                const SizedBox(height: 20),
                // Personal Information
                _buildDetailCard(
                  title: 'Personal Information',
                  children: [
                    _buildDetailItem(
                      icon: Icons.person,
                      label: 'Nama',
                      initialValue: nama,
                      onChanged: (value) => controller.nama.value = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    _buildDetailItem(
                      icon: Icons.email,
                      label: 'Email',
                      initialValue: email,
                      onChanged: (value) => controller.email.value = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Email wajib diisi' : null,
                    ),
                    _buildDetailItem(
                      icon: Icons.phone,
                      label: 'Nomor Telepon',
                      initialValue: noTelp,
                      onChanged: (value) => controller.noTelp.value = value,
                    ),
                    _buildDetailItem(
                      icon: Icons.location_on,
                      label: 'Alamat',
                      initialValue: alamat,
                      onChanged: (value) => controller.alamat.value = value,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Education (Coming Soon)
                _buildDetailCard(
                  title: 'Education',
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Coming Soon',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Tombol Simpan
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await controller.updateProfile();
                      if (controller.errorMessage.value.isEmpty) {
                        Get.back(); // Kembali ke ProfilePage setelah sukses
                      }
                    }
                  },
                  child: const Text('Save Profile'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileAvatar(String? fotoProfile) {
    if (fotoProfile == null || fotoProfile.isEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.blue[100],
        child: const Icon(Icons.person, size: 60, color: Colors.blue),
      );
    }

    final String baseUrl = Get.find<ApiClient>().dio.options.baseUrl;
    final String fullImageUrl =
        Uri.parse(baseUrl).resolve(fotoProfile).toString();

    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.blue[100],
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: fullImageUrl,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            color: Colors.blue[100],
            alignment: Alignment.center,
            child: const Icon(Icons.person, size: 60, color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4285F4),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String initialValue,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF4285F4)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  initialValue: initialValue,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: onChanged,
                  validator: validator,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
