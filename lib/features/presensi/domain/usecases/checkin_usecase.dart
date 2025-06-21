import 'package:smartelearn/services/presensi_service.dart';
import '../repositories/presensi_repository.dart';
import '../../domain/entities/presensi_entity.dart';

class CheckInUseCase {
  final PresensiRepository repository;

  CheckInUseCase(this.repository);

  Future<Presensi> call(Presensi presensi) async {
    if (presensi.batchId == null) {
      throw PresensiValidationException('batchId dan status wajib diisi');
    }
    return await repository.checkIn(presensi);
  }
}
