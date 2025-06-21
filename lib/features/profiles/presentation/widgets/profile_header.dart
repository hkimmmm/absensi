import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String nama;
  final String email;
  final String? fotoProfile;
  final String baseUrl = "http://192.168.18.9:3000";

  const ProfileHeader({
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
      // ignore: avoid_print
      print("DEBUG: fotoProfile kosong atau null, tampilkan icon default");
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blue[100],
        child: const Icon(Icons.person, size: 50, color: Colors.blue),
      );
    }

    // Pastikan baseUrl dan fotoProfile terhubung dengan benar
    final String fullImageUrl = fotoProfile!.startsWith('/')
        ? "$baseUrl$fotoProfile"
        : "$baseUrl/$fotoProfile";

    // ignore: avoid_print
    print("DEBUG: fullImageUrl = $fullImageUrl");

    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.blue[100],
      child: ClipOval(
        child: Image.network(
          fullImageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // ignore: avoid_print
            print("DEBUG: Gagal load gambar profile: $error");
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
