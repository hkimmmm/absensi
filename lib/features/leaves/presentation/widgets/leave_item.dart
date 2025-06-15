import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/leave_entity.dart';

class LeaveItemWidget extends StatelessWidget {
  final LeaveEntity leave;

  const LeaveItemWidget({super.key, required this.leave});

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = leave.status.toLowerCase() == 'approved'
        ? Colors.green[100]
        : leave.status.toLowerCase() == 'rejected'
            ? Colors.red[100]
            : Colors.orange[100];

    final statusTextColor = leave.status.toLowerCase() == 'approved'
        ? Colors.green[800]
        : leave.status.toLowerCase() == 'rejected'
            ? Colors.red[800]
            : Colors.orange[800];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row with Date and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date (left)
                Row(
                  children: [
                    const Icon(Icons.date_range, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${formatDate(leave.tanggalMulai)} - ${formatDate(leave.tanggalSelesai)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),

                // Status (right)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    leave.status,
                    style: TextStyle(
                      color: statusTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 20, thickness: 1),

            // Leave details below
            // Jenis Cuti
            Row(
              children: [
                const Icon(Icons.category, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text('Jenis Cuti: ${leave.jenis}'),
              ],
            ),

            const SizedBox(height: 8),

            // Keterangan
            if (leave.keterangan != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text('Keterangan: ${leave.keterangan}')),
                ],
              ),

            // Approved By
            if (leave.approvedBy != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text('Disetujui oleh: ${leave.approverUsername}'),
                  ],
                ),
              ),

            // Tanggal Pengajuan
            if (leave.createdAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text('Diajukan pada: ${formatDate(leave.createdAt!)}'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
