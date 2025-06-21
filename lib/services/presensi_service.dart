// import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:smartelearn/core/network/api_client.dart';
import 'package:smartelearn/features/presensi/data/models/presensi_model.dart';

class PresensiService {
  final ApiClient apiClient;
  final Logger logger;

  PresensiService({required this.apiClient, required this.logger});

  Future<List<PresensiModel>> getAllPresensi() async {
    try {
      final List<dynamic> response = await apiClient.getList('/presence');
      return response.map((json) => PresensiModel.fromJson(json)).toList();
    } on DioException catch (e) {
      _handleDioError(e);
      throw _parseError(e);
    } catch (e) {
      logger.e('Unexpected error: $e');
      throw PresensiServiceException('Failed to fetch presensi data');
    }
  }

  Future<Map<String, dynamic>> checkIn({
    required String status,
    required String batchId,
    double? checkinLat,
    double? checkinLng,
    String? id,
  }) async {
    try {
      final presensi = PresensiModel.forCheckIn(
        status: status,
        batchId: batchId,
        checkinLat: checkinLat,
        checkinLng: checkinLng,
      );
      logger.i('Payload check-in: ${presensi.toJson()}');
      final response =
          await apiClient.post('/checkin', data: presensi.toJson());
      logger.i('Respons check-in: $response');
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _parseError(e);
    } catch (e, stackTrace) {
      logger.e('Error check-in: $e, StackTrace: $stackTrace');
      throw PresensiServiceException('Gagal check-in: $e');
    }
  }

  Future<Map<String, dynamic>> checkOut({
    required String batchId,
    String? presensiId,
    double? checkoutLat,
    double? checkoutLng,
  }) async {
    try {
      if (batchId.isEmpty && (presensiId == null || presensiId.isEmpty)) {
        throw PresensiValidationException(
            'batchId atau presensiId wajib diisi');
      }
      final presensi = PresensiModel.forCheckOut(
        batchId: batchId.isEmpty ? '-' : batchId,
        presensiId: presensiId,
        checkoutLat: checkoutLat,
        checkoutLng: checkoutLng,
      );
      logger.i('⏏️ Sending checkout request to /checkout');
      logger.i('Payload: ${presensi.toJson(type: 'checkout')}');
      final response = await apiClient.post(
        '/checkout',
        data: presensi.toJson(type: 'checkout'),
      );
      logger.i('✅ Checkout response: $response');
      if (response['message'] != 'Check-out berhasil') {
        throw PresensiValidationException(response['message'] ??
            'Checkout gagal dengan status tidak diketahui');
      }
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _parseError(e);
    } catch (e, stackTrace) {
      logger
          .e('Unexpected error during check-out: $e, StackTrace: $stackTrace');
      throw PresensiServiceException('Gagal check-out: $e');
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
      return PresensiValidationException(
        e.response?.data['message'] ?? 'Invalid presensi data',
      );
    } else if (e.response?.statusCode == 401) {
      return UnauthorizedException();
    } else if (e.response?.statusCode == 404) {
      return NotFoundException('Presensi not found');
    } else {
      return PresensiServiceException(e.message ?? 'Presensi service error');
    }
  }
}

// Custom exceptions
class PresensiServiceException implements Exception {
  final String message;
  PresensiServiceException(this.message);
}

class PresensiValidationException extends PresensiServiceException {
  PresensiValidationException(super.message);
}

class UnauthorizedException extends PresensiServiceException {
  UnauthorizedException() : super('Unauthorized access');
}

class NotFoundException extends PresensiServiceException {
  NotFoundException(super.message);
}
