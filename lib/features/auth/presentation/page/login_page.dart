import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthController authController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final RxBool _obscurePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Pastikan konten bergeser saat keyboard muncul
      backgroundColor: Colors.white, // Latar belakang putih
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            reverse: true, // Membantu konten bergeser ke atas saat keyboard muncul
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Sesuaikan dengan tinggi keyboard
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400), // Batasi lebar form
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Judul
                    Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 32, // Kembali ke ukuran font awal
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800, // Tema biru
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12), // Jarak seperti kode awal
                    Text(
                      'Silakan masuk untuk melanjutkan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36), // Jarak seperti kode awal
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              labelText: "Email", // Kembali ke labelText
                              prefixIcon: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(Icons.email, color: Colors.blue), // Ikon dan warna biru
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30), // Pertahankan radius modern
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Email wajib diisi" : null,
                          ),
                          const SizedBox(height: 16),
                          Obx(() => TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword.value,
                                style: const TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  labelText: "Password", // Kembali ke labelText
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Icon(Icons.lock, color: Colors.blue), // Ikon dan warna biru
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: IconButton(
                                      icon: Icon(
                                        _obscurePassword.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.blue, // Warna biru
                                      ),
                                      onPressed: () {
                                        _obscurePassword.toggle();
                                      },
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30), // Pertahankan radius modern
                                  ),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? "Password wajib diisi" : null,
                              )),
                          const SizedBox(height: 24),
                          Obx(() => authController.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.blue, // Warna biru
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, // Tema biru
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30), // Radius modern
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.login, color: Colors.white), // Ikon login
                                        SizedBox(width: 8),
                                        Text(
                                          'Login', // Kembali ke teks awal
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          Obx(() => authController.errorMessage.value.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    authController.errorMessage.value,
                                    style: const TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : const SizedBox.shrink()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      authController
          .login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      )
          .then((_) {
        if (authController.user.value != null) {
          Get.offAllNamed('/dashboard');
        }
      });
    }
  }
}