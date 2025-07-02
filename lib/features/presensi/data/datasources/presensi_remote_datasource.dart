import 'package:smartelearn/services/presensi_service.dart';
import 'package:smartelearn/features/presensi/data/models/presensi_model.dart';

abstract class PresensiRemoteDatasource {
  Future<List<PresensiModel>> getPresensi();
  Future<PresensiModel> checkIn(PresensiModel data);
  Future<PresensiModel> checkOut(PresensiModel data);
}

class PresensiRemoteDatasourceImpl implements PresensiRemoteDatasource {
  final PresensiService service;

  PresensiRemoteDatasourceImpl({required this.service});

  @override
  Future<List<PresensiModel>> getPresensi() async {
    try {
      return await service.getAllPresensi();
    } on PresensiServiceException {
      rethrow;
    } catch (e) {
      throw PresensiServiceException('Unexpected error: $e');
    }
  }

  @override
  Future<PresensiModel> checkIn(PresensiModel data) async {
    try {
      final response = await service.checkIn(
        id: data.id,
        status: data.status ?? 'hadir',
        batchId: data.batchId ?? '',
        checkinLat: data.checkinLat,
        checkinLng: data.checkinLng,
      );
      if (response['message'] == 'Check-in berhasil') {
        return PresensiModel(
          id: response['presensiId']?.toString(),
          tanggal: data.tanggal ?? DateTime.now(),
          checkinTime: data.checkinTime ?? DateTime.now(),
          checkinLat: data.checkinLat,
          checkinLng: data.checkinLng,
          status: data.status ?? 'hadir',
          batchId: data.batchId,
          type: 'checkin',
        );
      } else {
        String message = response['message'] ?? 'Check-in gagal';
        // Potong detail jarak dan radius jika ada
        if (message.contains(',')) {
          message = message.split(',').first.trim();
        }
        throw PresensiServiceException(message);
      }
    } on PresensiServiceException {
      rethrow;
    } catch (e) {
      throw PresensiServiceException('Terjadi kesalahan tidak terduga');
    }
  }

  @override
  Future<PresensiModel> checkOut(PresensiModel data) async {
    try {
      if (data.batchId == null && data.presensiId == null) {
        throw PresensiValidationException(
            'batchId atau presensiId wajib diisi');
      }
      final response = await service.checkOut(
        batchId: data.batchId ?? '-',
        presensiId: data.presensiId,
        checkoutLat: data.checkoutLat,
        checkoutLng: data.checkoutLng,
      );
      return PresensiModel(
        id: response['presensiId']?.toString(),
        batchId: data.batchId,
        presensiId: data.presensiId,
        checkoutTime: data.checkoutTime,
        checkoutLat: data.checkoutLat,
        checkoutLng: data.checkoutLng,
      );
    } on PresensiServiceException {
      rethrow;
    } catch (e) {
      throw PresensiServiceException('Unexpected check-out error: $e');
    }
  }
}
