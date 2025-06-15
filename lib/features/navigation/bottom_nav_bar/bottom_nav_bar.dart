import 'package:flutter/material.dart';
import 'bottom_nav_items.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: bottomNavItems,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white, // Latar belakang putih
      selectedItemColor: Colors.blue, // Ikon aktif biru
      unselectedItemColor: Colors.grey, // Ikon non-aktif abu-abu
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }
}
