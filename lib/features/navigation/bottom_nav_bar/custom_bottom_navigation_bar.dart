// import 'package:flutter/material.dart';
// import '../controller/bottom_nav_controller.dart';
// import 'package:get/get.dart';

// // Bottom Navigation Items
// final List<BottomNavigationBarItem> bottomNavItems = [
//   const BottomNavigationBarItem(
//     icon: Icon(Icons.dashboard),
//     label: 'Dashboard',
//     tooltip: 'Dashboard',
//   ),
//   const BottomNavigationBarItem(
//     icon: Icon(Icons.calendar_today),
//     label: 'Leaves',
//     tooltip: 'Leaves',
//   ),
//   const BottomNavigationBarItem(
//     icon: Icon(Icons.qr_code),
//     label: 'QR Code',
//     tooltip: 'QR Code',
//   ),
//   const BottomNavigationBarItem(
//     icon: Icon(Icons.person),
//     label: 'Profile',
//     tooltip: 'Profile',
//   ),
// ];

// // Bottom Navigation Theme
// const BottomNavigationBarThemeData bottomNavTheme =
//     BottomNavigationBarThemeData(
//   backgroundColor: Colors.white,
//   selectedItemColor: Colors.blue,
//   unselectedItemColor: Colors.grey,
//   selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
//   showSelectedLabels: true,
//   showUnselectedLabels: true,
// );

// // Custom Bottom Navigation Bar Widget
// class CustomBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const CustomBottomNavigationBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final BottomNavController controller = Get.find<BottomNavController>();
//     return Obx(
//       () => BottomNavigationBar(
//         currentIndex: controller.currentIndex.value,
//         onTap: controller.changeIndex,
//         items: bottomNavItems,
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: bottomNavTheme.backgroundColor,
//         selectedItemColor: bottomNavTheme.selectedItemColor,
//         unselectedItemColor: bottomNavTheme.unselectedItemColor,
//         selectedLabelStyle: bottomNavTheme.selectedLabelStyle,
//         showSelectedLabels: bottomNavTheme.showSelectedLabels,
//         showUnselectedLabels: bottomNavTheme.showUnselectedLabels,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/bottom_nav_controller.dart';
import 'bottom_nav_items.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(
      builder: (controller) => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: (index) {
          if (controller.currentIndex.value != index) {
            controller.changeIndex(index);
            switch (index) {
              case 0:
                Get.offNamed('/dashboard');
                break;
              case 1:
                Get.offNamed('/leave');
                break;
              case 2:
                Get.offNamed('/presensi');
                break;
              case 3:
                Get.offNamed('/profile');
                break;
            }
          }
        },
        items: bottomNavItems,
        type: BottomNavigationBarType.fixed,
        backgroundColor: bottomNavTheme.backgroundColor,
        selectedItemColor: bottomNavTheme.selectedItemColor,
        unselectedItemColor: bottomNavTheme.unselectedItemColor,
        selectedLabelStyle: bottomNavTheme.selectedLabelStyle,
        showSelectedLabels: bottomNavTheme.showSelectedLabels,
        showUnselectedLabels: bottomNavTheme.showUnselectedLabels,
      ),
    );
  }
}
