import 'package:smartelearn/features/leaves/data/models/leave_model.dart';

abstract class LeaveRemoteDatasource {
  // Ambil semua leave milik user yang sedang login (tanpa parameter user id)
  Future<List<LeaveModel>> getLeaves();

  // Ambil leave user yang login, dengan filter status opsional
  Future<List<LeaveModel>> getLeavesByStatus(String status);

  // Alternatif method dengan parameter status opsional (lebih fleksibel)
  Future<List<LeaveModel>> getLeavesFiltered({String? status});

  // Submit pengajuan leave
  Future<LeaveModel> applyLeave(LeaveModel leave);
}
