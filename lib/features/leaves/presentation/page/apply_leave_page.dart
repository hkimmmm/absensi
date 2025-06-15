import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leave_controller.dart';
import '../widgets/leave_form.dart';

class ApplyLeavePage extends StatelessWidget {
  const ApplyLeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan controller sudah diinisialisasi
    Get.put(LeaveController(
      applyLeave: Get.find(),
      getLeaves: Get.find(),
    ));

    return Scaffold(
      backgroundColor: Colors.white, // Background putih
      appBar: AppBar(
        title: const Text(
          'Ajukan Cuti',
          style: TextStyle(color: Colors.white), // Teks putih
        ),
        backgroundColor: Colors.blue, // AppBar biru
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Ikon kembali putih
          onPressed: () => Get.back(), // Kembali ke halaman sebelumnya
        ),
        elevation: 4, // Sedikit bayangan untuk tampilan lebih menarik
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: LeaveForm(),
      ),
    );
  }
}
