import '../entities/presensi_entity.dart';
import '../repositories/presensi_repository.dart';

class GetDataUseCase {
  final PresensiRepository repository;

  GetDataUseCase(this.repository);

  Future<List<Presensi>> call() async {
    try {
      final result = await repository.getPresensi();
      return result;
    } catch (e) {
      throw Exception('Gagal mengambil data presensi: $e');
    }
  }
}
