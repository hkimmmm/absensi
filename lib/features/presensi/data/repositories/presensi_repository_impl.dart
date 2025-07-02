import '../../domain/entities/presensi_entity.dart';
import '../../domain/repositories/presensi_repository.dart';
import '../datasources/presensi_remote_datasource.dart';
import '../models/presensi_model.dart';

class PresensiRepositoryImpl implements PresensiRepository {
  final PresensiRemoteDatasource remote;

  PresensiRepositoryImpl(this.remote);

  @override
  Future<List<Presensi>> getPresensi() async {
    try {
      final models = await remote.getPresensi();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data presensi: $e');
    }
  }

  @override
  Future<Presensi> checkIn(Presensi presensi) async {
    try {
      print(
          'PresensiRepositoryImpl: checkIn dipanggil dengan presensi: $presensi');
      final model = await remote.checkIn(PresensiModel.fromEntity(presensi));
      print('PresensiRepositoryImpl: checkIn berhasil, model: $model');
      return model.toEntity();
    } catch (e, stackTrace) {
      print(
          'PresensiRepositoryImpl: Error checkIn: $e, StackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<Presensi> checkOut(Presensi presensi) async {
    try {
      print(
          'PresensiRepositoryImpl: checkOut dipanggil dengan presensi: $presensi');
      final model = await remote.checkOut(PresensiModel.fromEntity(presensi));
      print('PresensiRepositoryImpl: checkOut berhasil, model: $model');
      return model.toEntity();
    } catch (e, stackTrace) {
      print(
          'PresensiRepositoryImpl: Error checkOut: $e, StackTrace: $stackTrace');
      throw Exception('Gagal check-out: $e');
    }
  }
}
