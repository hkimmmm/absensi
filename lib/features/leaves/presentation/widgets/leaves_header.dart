import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartelearn/config/app_routes.dart';

class LeavesHeader extends StatelessWidget {
  final VoidCallback onFilterPressed;

  const LeavesHeader({
    super.key,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All Leaves',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          Row(
            children: [
              // [+] Button - Blue with white icon
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.applyleave),
                  color: Colors.white,
                  icon: const Icon(Icons.add),
                ),
              ),
              const SizedBox(width: 8),
              // Filter Button
              OutlinedButton(
                onPressed: onFilterPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Filter'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
