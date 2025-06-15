import 'info_card.dart';
import 'package:flutter/material.dart';

class AttendanceSection extends StatelessWidget {
  final String checkInTime;
  final String checkInStatus;
  final String checkOutTime;
  final String checkOutStatus;

  const AttendanceSection({
    super.key,
    required this.checkInTime,
    required this.checkInStatus,
    required this.checkOutTime,
    required this.checkOutStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InfoCard(
              title: 'Check In',
              value: checkInTime,
              status: checkInStatus,
              icon: Icons.login,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InfoCard(
              title: 'Check Out',
              value: checkOutTime,
              status: checkOutStatus,
              icon: Icons.logout,
            ),
          ),
        ],
      ),
    );
  }
}
