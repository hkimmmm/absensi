import 'package:smartelearn/features/leaves/domain/entities/leave_entity.dart';
import 'package:smartelearn/features/leaves/domain/repositories/leave_repository.dart';

class GetLeavesByStatus {
  final LeaveRepository repository;

  GetLeavesByStatus(this.repository);

  Future<List<LeaveEntity>> call(String status) async {
    // Bisa "pending", "approved", "rejected"
    return await repository.getLeavesByStatus(status);
  }
}
