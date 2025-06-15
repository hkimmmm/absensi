import 'dart:convert';
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
    double? checkinLat,
    double? checkinLng,
  }) async {
    try {
      final presensi = PresensiModel.forCheckIn(
        status: status,
        checkinLat: checkinLat,
        checkinLng: checkinLng,
      );
      logger.i('Presensi object toJson sebelum check-in: ${presensi.toJson()}');

      final response =
          await apiClient.post('/presence', data: presensi.toJson());
      logger.i('Raw response: $response');

      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _parseError(e);
    } catch (e) {
      logger.e('Unexpected error during check-in: $e');
      throw PresensiServiceException('Failed to check-in: $e');
    }
  }

  Future<PresensiModel> checkOut(String qrCode, PresensiModel presensi) async {
    try {
      // Dekode Base64 QR code
      final decodedBytes = base64Decode(qrCode);
      final decodedJson = utf8.decode(decodedBytes);
      final payload = jsonDecode(decodedJson);
      final presensiId = payload['token'].toString();

      // Await toCheckoutJson
      final checkoutData = await presensi.toCheckoutJson();
      logger.i('Presensi data untuk check-out: $checkoutData');

      final response = await apiClient.patch(
        '/presence/$presensiId',
        data: checkoutData,
      );

      logger.i('Raw response: $response');

      return PresensiModel.fromJson(response);
    } on DioException catch (e) {
      logger.e('Dio error: ${e.response?.data}');
      _handleDioError(e);
      throw _parseError(e);
    } catch (e) {
      logger.e('Unexpected error during check-out: $e');
      throw PresensiServiceException('Failed to check-out: $e');
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
