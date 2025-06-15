import '../repositories/presensi_repository.dart';
import '../../domain/entities/presensi_entity.dart';

class CheckOutUseCase {
  final PresensiRepository repository;

  CheckOutUseCase(this.repository);

  Future<Presensi> call(String presensiId, Presensi presensi) async {
    return await repository.checkOut(presensiId, presensi);
  }
}
