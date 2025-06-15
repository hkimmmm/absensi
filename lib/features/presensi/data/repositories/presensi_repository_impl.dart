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
    final model = await remote.checkIn(PresensiModel.fromEntity(presensi));
    return model.toEntity();
  }

  @override
  Future<Presensi> checkOut(String presensiId, Presensi presensi) async {
    final model =
        await remote.checkOut(presensiId, PresensiModel.fromEntity(presensi));
    return model.toEntity();
  }
}
