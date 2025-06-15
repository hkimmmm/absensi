import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartelearn/features/leaves/presentation/controllers/leave_controller.dart';

class LeavesSummary extends StatelessWidget {
  const LeavesSummary({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the LeaveController instance
    final LeaveController controller = Get.find<LeaveController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.error.value != null) {
        return Center(child: Text('Error: ${controller.error.value}'));
      }

      // Calculate summary counts
      final pendingCount = controller.leaves
          .where((leave) => leave.status == 'pending')
          .length
          .toString();
      final approvedCount = controller.leaves
          .where((leave) => leave.status == 'approved')
          .length
          .toString();
      final rejectedCount = controller.leaves
          .where((leave) => leave.status == 'rejected')
          .length
          .toString();
      // Placeholder for leave balance since it's not available
      const leaveBalance = 'N/A';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SummaryCard(title: 'Leave Balance', value: leaveBalance),
            _SummaryCard(title: 'Leave Pending', value: pendingCount),
            _SummaryCard(title: 'Leave Approved', value: approvedCount),
            _SummaryCard(title: 'Leave Cancelled', value: rejectedCount),
          ],
        ),
      );
    });
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
