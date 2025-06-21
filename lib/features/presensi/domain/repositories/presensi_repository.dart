import '../entities/presensi_entity.dart';

abstract class PresensiRepository {
  Future<List<Presensi>> getPresensi();

  Future<Presensi> checkIn(Presensi presensi);

  Future<Presensi> checkOut(Presensi presensi);
}
