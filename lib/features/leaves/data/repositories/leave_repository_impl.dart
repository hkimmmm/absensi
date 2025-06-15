import 'package:smartelearn/features/leaves/data/datasources/leave_remote_data_source.dart';
import 'package:smartelearn/features/leaves/domain/entities/leave_entity.dart';
import 'package:smartelearn/features/leaves/domain/repositories/leave_repository.dart';
import 'package:smartelearn/features/leaves/data/models/leave_model.dart';
import 'package:smartelearn/services/leave_service.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDatasource remoteDatasource;

  LeaveRepositoryImpl(
      {required this.remoteDatasource, required LeaveService leaveService});

  @override
  Future<List<LeaveEntity>> getLeaves() async {
    final models = await remoteDatasource.getLeaves();
    return models;
  }

  @override
  Future<List<LeaveEntity>> getLeavesByStatus(String status) async {
    final models = await remoteDatasource.getLeavesByStatus(status);
    return models;
  }

  @override
  Future<LeaveEntity> applyLeave(LeaveEntity leave) async {
    final model =
        await remoteDatasource.applyLeave(LeaveModel.fromEntity(leave));
    return model;
  }
}
