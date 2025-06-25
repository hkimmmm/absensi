
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartelearn/features/dashboard/presentation/widgets/header.dart';
import 'package:smartelearn/features/dashboard/presentation/widgets/day_chips.dart';
import 'package:smartelearn/features/dashboard/presentation/widgets/info_card.dart';
import 'package:smartelearn/features/navigation/bottom_nav_bar/custom_bottom_navigation_bar.dart';
import 'package:smartelearn/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:smartelearn/features/presensi/presentation/controllers/presensi_controller.dart';
import 'package:smartelearn/features/dashboard/presentation/widgets/activity_section.dart';
import 'package:smartelearn/features/dashboard/presentation/widgets/attendance_section.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key}); // Menggunakan super parameter

  Future<void> initLocale() async {
    await initializeDateFormatting('id_ID', null);
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    final local = dateTime.toLocal();
    return '${DateFormat('dd MMM yyyy - HH:mm', 'id_ID').format(local)} WIB';
  }

  String formatTimeOnly(DateTime? dateTime) {
    if (dateTime == null) return '-';
    final local = dateTime.toLocal();
    return '${DateFormat('HH:mm', 'id_ID').format(local)} WIB';
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final presensiController = Get.find<PresensiController>();

    // Panggil loadPresensi saat halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      presensiController.loadPresensi();
    });

    // Atur tampilan status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    final now = DateTime.now();
    final dates = List.generate(4, (index) => now.add(Duration(days: index)));

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
          body: RefreshIndicator(
            onRefresh: () async {
              await presensiController.loadPresensi();
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Obx(() {
                    final controller = Get.find<DashboardController>();
                    final user = controller.userInfoFromRepo.value;

                    final nama = user?.nama ?? 'Tamu';
                    final position = user?.role ?? 'Karyawan';
                    final fotoProfile = user?.fotoProfile;

                    return HeaderProfile(
                      nama: nama,
                      position: position,
                      fotoProfile: fotoProfile,
                      onNotificationPressed: () {
                        debugPrint('Tombol notifikasi ditekan');
                      },
                    );
                  }),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DayChips(
                      dates: dates,
                      currentDate: now,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                          child: Text(
                            'Kehadiran Hari Ini',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Obx(() {
                          final list = presensiController.presensiList;
                          final today = DateTime.now();
                          final todayPresensi = list.firstWhereOrNull(
                            (item) =>
                                item.checkinTime != null &&
                                isSameDay(item.checkinTime!, today),
                          );

                          return AttendanceSection(
                            checkInTime: todayPresensi != null
                                ? formatTimeOnly(todayPresensi.checkinTime)
                                : null,
                            checkInStatus: todayPresensi?.status ?? 'Menunggu',
                            checkOutTime: todayPresensi?.checkoutTime != null
                                ? formatTimeOnly(todayPresensi?.checkoutTime)
                                : null,
                            checkOutStatus: todayPresensi?.checkoutTime != null
                                ? 'Pulang'
                                : null,
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: InfoCard(
                                  title: 'Waktu Istirahat',
                                  value: '60:00 menit',
                                  status: 'Rata-rata 1 jam',
                                  icon: Icons.access_time,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: InfoCard(
                                  title: 'Total Hari',
                                  value: '28',
                                  status: 'Hari Kerja',
                                  icon: Icons.calendar_today,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Obx(() {
                    final list = presensiController.presensiList;
                    if (list.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Belum ada data presensi."),
                      );
                    }

                    // Filter dan urutkan list untuk menghindari null
                    final sortedList = list
                        .where((item) => item.checkinTime != null)
                        .toList()
                      ..sort((a, b) => b.checkinTime!.compareTo(a.checkinTime!));

                    if (sortedList.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Belum ada data presensi dengan check-in."),
                      );
                    }

                    final item = sortedList.first;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ActivitySection(
                        checkInDate: formatDateTime(item.checkinTime),
                        checkInTime: formatDateTime(item.checkinTime),
                        checkInStatus: item.status ?? 'Menunggu',
                        checkOutDate: item.checkoutTime != null
                            ? formatDateTime(item.checkoutTime)
                            : null,
                        checkOutTime: item.checkoutTime != null
                            ? formatDateTime(item.checkoutTime)
                            : null,
                        breakInDate: null,
                        breakInTime: null,
                        breakOutDate: null,
                        breakOutTime: null,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(),
        );
      },
    );
  }
}
