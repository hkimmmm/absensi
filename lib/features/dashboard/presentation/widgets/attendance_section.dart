import 'package:flutter/material.dart';
import '../widgets/info_card.dart';

class AttendanceSection extends StatelessWidget {
  final String? checkInTime;
  final String checkInStatus;
  final String? checkOutTime;
  final String? checkOutStatus;

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: InfoCard(
              title: 'Check In',
              value: checkInTime ?? '-', // Gunakan '-' jika null
              status: checkInStatus,
              icon: Icons.login,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InfoCard(
              title: 'Check Out',
              value: checkOutTime ?? '-', // Gunakan '-' jika null
              status: checkOutStatus ?? '-', // Gunakan '-' jika null
              icon: Icons.logout,
            ),
          ),
        ],
      ),
    );
  }
}
