import 'package:smartelearn/features/leaves/domain/entities/leave_entity.dart';
import 'package:smartelearn/features/leaves/domain/repositories/leave_repository.dart';

class ApplyLeave {
  final LeaveRepository repository;

  ApplyLeave(this.repository);

  Future<LeaveEntity> call(LeaveEntity leave) async {
    return await repository.applyLeave(leave);
  }
}
