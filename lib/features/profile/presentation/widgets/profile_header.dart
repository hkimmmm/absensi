import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:smartelearn/core/network/api_client.dart';

class ProfileHeader extends StatelessWidget {
  final String nama;
  final String email;
  final String? fotoProfile;
  final logger = Logger();

  ProfileHeader({
    super.key,
    required this.nama,
    required this.email,
    this.fotoProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4285F4), Color(0xFF34A853)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Profile picture with border
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: _buildProfileAvatar(),
          ),
          const SizedBox(height: 16),
          Text(
            nama,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            email,
            style: TextStyle(
              fontSize: 16,
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    if (fotoProfile == null || fotoProfile!.isEmpty) {
      logger.d("fotoProfile kosong atau null, tampilkan icon default");
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blue[100],
        child: const Icon(Icons.person, size: 50, color: Colors.blue),
      );
    }

    // Ambil baseUrl dari ApiClient
    final String baseUrl = Get.find<ApiClient>().dio.options.baseUrl;
    final String fullImageUrl =
        Uri.parse(baseUrl).resolve(fotoProfile!).toString();
    logger.d("fullImageUrl = $fullImageUrl");

    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.blue[100],
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: fullImageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) {
            logger.e("Gagal load gambar profile: $error");
            return Container(
              color: Colors.blue[100],
              alignment: Alignment.center,
              child: const Icon(Icons.person, size: 50, color: Colors.blue),
            );
          },
        ),
      ),
    );
  }
}
