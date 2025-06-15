import 'package:smartelearn/services/leave_service.dart';
import 'package:smartelearn/features/leaves/data/models/leave_model.dart';
import 'package:smartelearn/features/leaves/data/datasources/leave_remote_data_source.dart';

class LeaveRemoteDatasourceImpl implements LeaveRemoteDatasource {
  final LeaveService leaveService;

  LeaveRemoteDatasourceImpl({required this.leaveService});

  @override
  Future<List<LeaveModel>> getLeaves() async {
    try {
      final response = await leaveService.apiClient.getList('/leave');
      return response.map((json) => LeaveModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LeaveModel>> getLeavesByStatus(String status) async {
    try {
      final response = await leaveService.apiClient.getList(
        '/leave',
        queryParameters: {'status': status},
      );
      return response.map((json) => LeaveModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LeaveModel>> getLeavesFiltered({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;

      final response = await leaveService.apiClient.getList(
        '/leave',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      return response.map((json) => LeaveModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LeaveModel> applyLeave(LeaveModel leave) async {
    return await leaveService.applyLeave(leave);
  }
}
