import 'package:smartelearn/services/presensi_service.dart';
import 'package:smartelearn/features/presensi/data/models/presensi_model.dart';

abstract class PresensiRemoteDatasource {
  Future<List<PresensiModel>> getPresensi();

  // Ubah return type jadi PresensiModel
  Future<PresensiModel> checkIn(PresensiModel data);

  Future<PresensiModel> checkOut(String presensiId, PresensiModel data);
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
        status: data.status,
        checkinLat: data.checkinLat,
        checkinLng: data.checkinLng,
      );
      return PresensiModel.fromJson(response);
    } on PresensiServiceException {
      rethrow;
    } catch (e) {
      throw PresensiServiceException('Unexpected check-in error: $e');
    }
  }

  @override
  Future<PresensiModel> checkOut(String presensiId, PresensiModel data) async {
    try {
      final response = await service.checkOut(presensiId, data);
      return response;
    } on PresensiServiceException {
      rethrow;
    } catch (e) {
      throw PresensiServiceException('Unexpected check-out error: $e');
    }
  }
}
