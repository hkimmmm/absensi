import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_routes.dart';
import 'package:smartelearn/features/auth/presentation/controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Animation duration
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Start animation
    _controller.forward();

    // Check login status and navigate after 2 seconds
    Future.delayed(const Duration(seconds: 2), () async {
      final AuthController authController = Get.find<AuthController>();
      bool isLoggedIn = await authController.isLoggedIn();
      if (isLoggedIn) {
        // Opsional: Validasi token jika diperlukan
        // Misalnya, panggil API untuk memverifikasi token
        Get.offNamed(AppRoutes.dashboard); // Ke dashboard jika sudah login
      } else {
        Get.offNamed(AppRoutes.login); // Ke login jika belum login
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'assets/icons/icon.png',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'CV CITRA BUANA CEMELRANG',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Solid blue color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
