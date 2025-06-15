import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:smartelearn/core/network/api_client.dart';
import 'package:smartelearn/features/leaves/data/models/leave_model.dart';

class LeaveService {
  final ApiClient apiClient;
  final Logger logger;

  LeaveService({required this.apiClient, required this.logger});

  Future<List<LeaveModel>> getLeaves() async {
    try {
      final List<dynamic> response = await apiClient.getList('/leave');
      // langsung map dari response
      return response.map((json) => LeaveModel.fromJson(json)).toList();
    } on DioException catch (e) {
      _handleDioError(e);
      throw _parseError(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
      throw LeaveServiceException('Failed to fetch leaves');
    }
  }

  // Future<LeaveModel> applyLeave(LeaveModel leave) async {
  //   try {
  //     logger.i('Leave object toJson sebelum applyLeave: ${leave.toJson()}');

  //     final response = await apiClient.post('/leave', data: leave.toJson());

  //     logger.i('Raw response: $response');

  //     final data = response;

  //     // Debug field penting sebelum parse
  //     logger.i('Parsing response fields:');
  //     logger.i('jenis: ${data['jenis']}');
  //     logger.i('tanggal_mulai: ${data['tanggal_mulai']}');
  //     logger.i('tanggal_selesai: ${data['tanggal_selesai']}');
  //     logger.i('status: ${data['status']}');

  //     // Bisa tambah validasi manual sebelum fromJson
  //     if (data['jenis'] == null || data['status'] == null) {
  //       throw LeaveServiceException('Field jenis/status tidak boleh null');
  //     }

  //     return LeaveModel.fromJson(data);
  //   } on DioException catch (e) {
  //     _handleDioError(e);
  //     throw _parseError(e);
  //   } catch (e) {
  //     logger.e('Unexpected error: $e');
  //     throw LeaveServiceException('Failed to apply leave: $e');
  //   }
  // }
  Future<LeaveModel> applyLeave(LeaveModel leave) async {
    try {
      logger.i('Leave object toJson sebelum applyLeave: ${leave.toJson()}');

      final response = await apiClient.post('/leave', data: leave.toJson());

      logger.i('Raw response: $response');

      final data = response;

      // Gunakan data input untuk field yang hilang
      if (data['id'] != null) {
        return LeaveModel(
          id: data['id'],
          jenis: leave.jenis,
          tanggalMulai: leave.tanggalMulai,
          tanggalSelesai: leave.tanggalSelesai,
          status: leave.status,
          keterangan: leave.keterangan,
          fotoBukti: leave.fotoBukti,
          approvedBy: leave.approvedBy,
          createdAt: leave.createdAt,
          updatedAt: leave.updatedAt,
          karyawanNama: leave.karyawanNama,
          approverUsername: leave.approverUsername,
        );
      }

      throw LeaveServiceException('Respons tidak valid');
    } on DioException catch (e) {
      _handleDioError(e);
      throw _parseError(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
      throw LeaveServiceException('Gagal mengajukan cuti: $e');
    }
  }

  void _handleDioError(DioException e) {
    if (e.response != null) {
      logger.e('Error status: ${e.response?.statusCode}');
      logger.e('Error data: ${e.response?.data}');
    } else {
      logger.e('Dio error: ${e.message}');
    }
  }

  Exception _parseError(DioException e) {
    if (e.response?.statusCode == 400) {
      return LeaveValidationException(
          e.response?.data['message'] ?? 'Invalid leave data');
    } else if (e.response?.statusCode == 401) {
      return UnauthorizedException();
    } else if (e.response?.statusCode == 404) {
      return NotFoundException('Leave resource not found');
    } else {
      return LeaveServiceException(e.message ?? 'Leave service error');
    }
  }
}

// Custom exceptions
class LeaveServiceException implements Exception {
  final String message;
  LeaveServiceException(this.message);
}

class LeaveValidationException extends LeaveServiceException {
  LeaveValidationException(super.message);
}

class UnauthorizedException extends LeaveServiceException {
  UnauthorizedException() : super('Unauthorized access');
}

class NotFoundException extends LeaveServiceException {
  NotFoundException(super.message);
}
