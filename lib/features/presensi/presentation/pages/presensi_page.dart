import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smartelearn/config/app_routes.dart';
import 'package:smartelearn/features/navigation/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:smartelearn/features/navigation/controller/bottom_nav_controller.dart';
import '../controllers/presensi_controller.dart';
import './checkin.dart';
import './checkout.dart';

class PresensiPage extends StatelessWidget {
  const PresensiPage({super.key});

  Future<void> initLocale() async {
    await initializeDateFormatting('id_ID', null);
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    final local = dateTime.toLocal();
    return '${DateFormat('dd MMM yyyy - HH:mm', 'id_ID').format(local)} WIB';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PresensiController>();
    final navController = Get.find<BottomNavController>();

    return FutureBuilder(
      future: initLocale(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Presensi'),
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final hasTodayPresensi = controller.hasActivePresensiToday;

                  return Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: !hasTodayPresensi
                              ? () => Get.to(() => const CheckinPage())
                              : null,
                          icon: const Icon(Icons.login),
                          label: const Text('Check-In'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                !hasTodayPresensi ? Colors.blue : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            disabledBackgroundColor: Colors.grey[400],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: hasTodayPresensi
                              ? () => Get.to(() => const CheckoutPage())
                              : null,
                          icon: const Icon(Icons.logout),
                          label: const Text('Check-Out'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                hasTodayPresensi ? Colors.red : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            disabledBackgroundColor: Colors.grey[400],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 24),
                const Text(
                  'Daftar Riwayat Presensi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.presensiList.isEmpty) {
                      return const Center(
                        child: Text(
                          "Belum ada data presensi.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.presensiList.length,
                      itemBuilder: (context, index) {
                        final item = controller.presensiList[index];

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(
                              item.checkoutTime == null
                                  ? Icons.timelapse
                                  : Icons.check_circle,
                              color: item.checkoutTime == null
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                            title: Text(
                              'Check-In: ${formatDateTime(item.checkinTime)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              'Check-Out: ${formatDateTime(item.checkoutTime)}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing: Text(
                              item.status!.toUpperCase(),
                              style: TextStyle(
                                color: item.status == 'hadir'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Obx(
            () => CustomBottomNavigationBar(
              currentIndex: navController.currentIndex.value,
              onTap: (index) => _handleNavigation(index, navController),
            ),
          ),
        );
      },
    );
  }

  void _handleNavigation(int index, BottomNavController navController) {
    navController.changeIndex(index);
    switch (index) {
      case 0:
        Get.offNamedUntil(AppRoutes.dashboard, (route) => false);
        break;
      case 1:
        Get.offNamedUntil(AppRoutes.leave, (route) => false);
        break;
      case 2:
        break;
    }
  }
}
