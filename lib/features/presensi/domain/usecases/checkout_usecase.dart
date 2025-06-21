import '../repositories/presensi_repository.dart';
import '../../domain/entities/presensi_entity.dart';
import 'package:smartelearn/services/presensi_service.dart';

class CheckOutUseCase {
  final PresensiRepository repository;

  CheckOutUseCase(this.repository);

  Future<Presensi> call(Presensi presensi) async {
    if (presensi.batchId == null || presensi.batchId!.isEmpty) {
      throw PresensiValidationException('batchId wajib diisi');
    }
    if (presensi.status == 'hadir' &&
        (presensi.checkoutLat == null || presensi.checkoutLng == null)) {
      throw PresensiValidationException(
          'Lokasi wajib diisi untuk status hadir');
    }
    return await repository.checkOut(presensi);
  }
}
