import 'package:get/get.dart';
import 'package:smartelearn/features/auth/presentation/page/login_page.dart';
import 'package:smartelearn/features/dashboard/presentation/page/dashboard_page.dart';
import 'package:smartelearn/features/leaves/presentation/page/leave_page.dart';
import 'package:smartelearn/features/leaves/presentation/page/apply_leave_page.dart';
import 'package:smartelearn/features/presensi/presentation/pages/checkin.dart';
import 'package:smartelearn/features/presensi/presentation/pages/checkout.dart';
import 'package:smartelearn/features/presensi/presentation/pages/presensi_page.dart';
import 'package:smartelearn/features/profile/presentation/pages/profile.dart';
import 'package:smartelearn/features/profile/presentation/pages/profile_detail_page.dart';
import 'package:smartelearn/features/splash/presentation/screens/splash_screen.dart';

import 'package:smartelearn/core/bindings/core_binding.dart';
import 'package:smartelearn/core/bindings/auth_binding.dart';
import 'package:smartelearn/core/bindings/dashboard_binding.dart';
import 'package:smartelearn/core/bindings/leave_binding.dart';
import 'package:smartelearn/core/bindings/presensi_binding.dart';
import 'package:smartelearn/core/bindings/profile_binding.dart';
import 'package:smartelearn/core/bindings/navigation_binding.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const leave = '/leave';
  static const applyleave = '/applyleave';
  static const qrcode = '/qr-code';
  static const checkin = '/checkin';
  static const checkout = '/checkout';
  static const presensi = '/presensi';
  static const profile = '/profile';
  static const profiledetail = '/profiledetail';

  static final pages = [
    GetPage(name: splash, page: () => SplashScreen(), binding: CoreBinding()),
    GetPage(
      name: login,
      page: () => LoginPage(),
      bindings: [
        CoreBinding(),
        AuthBinding()
      ],
    ),
    GetPage(
      name: dashboard,
      page: () => DashboardPage(),
      bindings: [
        CoreBinding(),
        AuthBinding(),
        NavigationBinding(),
        LeaveBinding(),
        PresensiBinding(),
        DashboardBinding(),
      ],
    ),
    GetPage(
      name: leave,
      page: () => LeavePage(),
      bindings: [
        CoreBinding(),
        AuthBinding(),
        DashboardBinding(),
        NavigationBinding(),
        LeaveBinding(),
      ],
    ),
    GetPage(
      name: applyleave,
      page: () => ApplyLeavePage(),
      bindings: [
        LeaveBinding(),
        AuthBinding(), // Tambahkan ini
      ],
    ),
    GetPage(
      name: presensi,
      page: () => PresensiPage(),
      bindings: [
        CoreBinding(),
        AuthBinding(),
        PresensiBinding(),
        NavigationBinding(),
      ],
    ),
    GetPage(
      name: checkin,
      page: () => CheckinPage(),
      bindings: [
        CoreBinding(),
        AuthBinding(),
        PresensiBinding(),
      ],
    ),
    GetPage(
      name: checkout,
      page: () => CheckoutPage(),
      bindings: [
        CoreBinding(),
        AuthBinding(),
        PresensiBinding(),
      ],
    ),
    GetPage(
      name: profile,
      page: () => ProfilePage(),
      bindings: [
        CoreBinding(),
        AuthBinding(),
        NavigationBinding(),
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: profiledetail,
      page: () => ProfileDetailPage(),
      bindings: [
        CoreBinding(),
        AuthBinding(),
        ProfileBinding(),
      ],
    ),
  ];
}
