import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leave_controller.dart';
import '../widgets/leaves_header.dart';
import '../widgets/leaves_summary.dart';
import '../widgets/leaves_tabs.dart';
import 'package:smartelearn/features/navigation/bottom_nav_bar/custom_bottom_navigation_bar.dart';

class LeavePage extends StatelessWidget {
  const LeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    final leaveController = Get.find<LeaveController>();

    // Tambahkan inisialisasi data saat pertama kali dibuka
    leaveController.fetchAllLeaves();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await leaveController.fetchAllLeaves();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: LeavesHeader(
                  onFilterPressed: () =>
                      _showFilterDialog(context, leaveController),
                ),
              ),

              // Loading atau summary
              Obx(() {
                if (leaveController.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (leaveController.error.value != null) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: ${leaveController.error.value}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return const LeavesSummary();
                }
              }),

              const SizedBox(height: 16),

              // Daftar cuti
              Obx(() {
                if (leaveController.isLoading.value) {
                  return const SizedBox.shrink();
                }

                if (leaveController.error.value != null) {
                  return const SizedBox.shrink();
                }

                // Pastikan leaves tidak kosong
                if (leaveController.leaves.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Tidak ada data cuti'),
                  );
                }

                // Hitung data upcoming dan past di sini supaya reactive
                final now = DateTime.now();
                final upcomingLeaves = leaveController.leaves
                    .where((leave) => leave.tanggalMulai.isAfter(now))
                    .toList();
                final pastLeaves = leaveController.leaves
                    .where((leave) =>
                        leave.tanggalMulai.isBefore(now) ||
                        leave.tanggalMulai.isAtSameMomentAs(now))
                    .toList();

                return LeavesTabs(
                  upcomingLeaves: upcomingLeaves,
                  pastLeaves: pastLeaves,
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  void _showFilterDialog(BuildContext context, LeaveController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Cuti'),
        content: const Text('Fitur filter akan segera tersedia'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
