import 'package:smartelearn/features/leaves/domain/entities/leave_entity.dart';

// Definisikan enum untuk status (sesuai backend)
enum LeaveStatus { pending, approved, rejected }

// Custom exceptions
class LeaveRepositoryException implements Exception {
  final String message;
  LeaveRepositoryException(this.message);
}

class LeaveNotFoundException extends LeaveRepositoryException {
  LeaveNotFoundException() : super('Leave request not found');
}

class InvalidStatusException extends LeaveRepositoryException {
  InvalidStatusException() : super('Invalid status provided');
}

class UnauthorizedApprovalException extends LeaveRepositoryException {
  UnauthorizedApprovalException() : super('Approver not authorized');
}

abstract class LeaveRepository {
  Future<List<LeaveEntity>> getLeaves();

  Future<List<LeaveEntity>> getLeavesByStatus(String status);

  /// Mengajukan leave baru
  /// [throws LeaveRepositoryException] jika data tidak valid atau terjadi error
  Future<LeaveEntity> applyLeave(LeaveEntity leave);

  /// Update status leave (approved/rejected)
  /// [throws LeaveNotFoundException] jika leaveId tidak ditemukan
  /// [throws InvalidStatusException] jika status tidak valid
  /// [throws UnauthorizedApprovalException] jika approvedBy tidak berwenang
  /// [throws LeaveRepositoryException] untuk error lainnya
}
