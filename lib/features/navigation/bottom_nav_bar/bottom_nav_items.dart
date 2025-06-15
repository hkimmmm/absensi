import 'package:flutter/material.dart';

final List<BottomNavigationBarItem> bottomNavItems = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.dashboard),
    label: 'Dashboard',
    tooltip: 'Dashboard',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.calendar_today),
    label: 'Leaves',
    tooltip: 'Leaves',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.qr_code),
    label: 'QR Code',
    tooltip: 'QR Code',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'Profile',
    tooltip: 'Profile',
  ),
];

const BottomNavigationBarThemeData bottomNavTheme =
    BottomNavigationBarThemeData(
  backgroundColor: Colors.white,
  selectedItemColor: Colors.blue,
  unselectedItemColor: Colors.grey,
  selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  showSelectedLabels: true,
  showUnselectedLabels: true,
);
