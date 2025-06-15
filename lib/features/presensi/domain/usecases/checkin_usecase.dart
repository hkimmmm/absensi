import '../repositories/presensi_repository.dart';
import '../../domain/entities/presensi_entity.dart';

class CheckInUseCase {
  final PresensiRepository repository;

  CheckInUseCase(this.repository);

  Future<Presensi> call(Presensi presensi) async {
    return await repository.checkIn(presensi);
  }
}
