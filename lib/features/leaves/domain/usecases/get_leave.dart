import 'package:smartelearn/features/leaves/domain/entities/leave_entity.dart';
import 'package:smartelearn/features/leaves/domain/repositories/leave_repository.dart';

class GetLeaves {
  final LeaveRepository repository;

  GetLeaves(this.repository);

  Future<List<LeaveEntity>> call() async {
    return await repository.getLeaves();
  }
}
