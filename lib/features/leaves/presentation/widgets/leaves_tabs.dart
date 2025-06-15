import 'package:flutter/material.dart';
import '../../domain/entities/leave_entity.dart';
import './leave_item.dart';

class LeavesTabs extends StatelessWidget {
  final List<LeaveEntity> upcomingLeaves;
  final List<LeaveEntity> pastLeaves;

  const LeavesTabs({
    super.key,
    required this.upcomingLeaves,
    required this.pastLeaves,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildLeaveList(upcomingLeaves),
                _buildLeaveList(pastLeaves),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveList(List<LeaveEntity> leaves) {
    if (leaves.isEmpty) {
      return const Center(
        child: Text('Tidak ada data cuti.'),
      );
    }

    return ListView.builder(
      itemCount: leaves.length,
      itemBuilder: (context, index) {
        return LeaveItemWidget(leave: leaves[index]);
      },
    );
  }
}
