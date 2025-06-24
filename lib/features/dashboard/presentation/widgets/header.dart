import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:smartelearn/core/network/api_client.dart';

class HeaderProfile extends StatelessWidget {
  final String nama;
  final String position;
  final String? fotoProfile;
  final VoidCallback? onNotificationPressed;
  final Logger logger = Logger();

  HeaderProfile({
    super.key,
    required this.nama,
    required this.position,
    this.fotoProfile,
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto Profil
          _buildProfileAvatar(),

          const SizedBox(width: 16),

          // Nama dan Posisi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  position,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Tombol Notifikasi
          _buildNotificationButton(),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    if (fotoProfile == null || fotoProfile!.isEmpty) {
      logger.d("fotoProfile kosong atau null, tampilkan icon default");
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.blue[100],
        child: const Icon(Icons.person, size: 30, color: Colors.blue),
      );
    }

    // Ambil baseUrl dari ApiClient
    final String baseUrl = Get.find<ApiClient>().dio.options.baseUrl;
    final String fullImageUrl =
        Uri.parse(baseUrl).resolve(fotoProfile!).toString();
    logger.d("fullImageUrl = $fullImageUrl");

    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blue[100],
      child: ClipOval(
        child: Image.network(
          fullImageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            logger.e("Gagal load gambar profile: $error");
            return Container(
              color: Colors.blue[100],
              alignment: Alignment.center,
              child: const Icon(Icons.person, size: 30, color: Colors.blue),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      width: 48,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: IconButton(
        icon: const Icon(Icons.notifications_none),
        color: Colors.grey[600],
        iconSize: 28,
        padding: EdgeInsets.zero,
        onPressed: onNotificationPressed,
      ),
    );
  }
}
