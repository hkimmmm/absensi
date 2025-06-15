import 'package:flutter/material.dart';
import '../widgets/info_card.dart';

class ActivitySection extends StatelessWidget {
  final String checkInDate;
  final String checkInTime;
  final String checkInStatus;
  final String? checkOutDate;
  final String? checkOutTime;
  final String? breakInDate;
  final String? breakInTime;
  final String? breakOutDate;
  final String? breakOutTime;
  final VoidCallback? onViewAllPressed;

  const ActivitySection({
    super.key,
    required this.checkInDate,
    required this.checkInTime,
    required this.checkInStatus,
    this.checkOutDate,
    this.checkOutTime,
    this.breakInDate,
    this.breakInTime,
    this.breakOutDate,
    this.breakOutTime,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          InfoCard(
            title: 'Check In',
            value: checkInTime,
            status: checkInStatus,
            date: checkInDate,
            icon: Icons.login,
          ),
          if (checkOutTime != null && checkOutDate != null) ...[
            const SizedBox(height: 16),
            InfoCard(
              title: 'Check Out',
              value: checkOutTime!,
              status: checkInStatus, // Use same status or adjust if needed
              date: checkOutDate,
              icon: Icons.logout,
            ),
          ],
          if (breakInTime != null && breakInDate != null) ...[
            const SizedBox(height: 16),
            InfoCard(
              title: 'Break In',
              value: breakInTime!,
              status: null,
              date: breakInDate,
              icon: Icons.coffee,
            ),
          ],
          if (breakOutTime != null && breakOutDate != null) ...[
            const SizedBox(height: 16),
            InfoCard(
              title: 'Break Out',
              value: breakOutTime!,
              status: null,
              date: breakOutDate,
              icon: Icons.coffee_outlined,
            ),
          ],
        ],
      ),
    );
  }
}
