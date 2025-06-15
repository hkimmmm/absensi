import 'package:get/get.dart';
import '../../domain/entities/presensi_entity.dart';
import '../../domain/usecases/checkin_usecase.dart';
import '../../domain/usecases/checkout_usecase.dart';
import '../../domain/usecases/get_data_usecase.dart';

class PresensiController extends GetxController {
  final CheckInUseCase checkInUseCase;
  final CheckOutUseCase checkOutUseCase;
  final GetDataUseCase getDataUseCase;

  PresensiController({
    required this.checkInUseCase,
    required this.checkOutUseCase,
    required this.getDataUseCase,
  });

  // Observables
  var presensiList = <Presensi>[].obs;
  var isLoading = false.obs;
  var error = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadPresensi();
  }

  /// Load data presensi
  Future<void> loadPresensi() async {
    _startLoading();
    try {
      final data = await getDataUseCase.call();
      presensiList.assignAll(data);
      error.value = null;
      print("Data presensi loaded: ${data.length} items");
    } catch (e) {
      error.value = 'Gagal memuat data: ${e.toString()}';
      Get.snackbar('Error', error.value!);
      print('Error details: $e');
    } finally {
      _stopLoading();
    }
  }

  /// Refresh data
  Future<void> refreshData() async {
    await loadPresensi();
  }

  /// Check-in
  Future<Presensi?> checkIn(Presensi data) async {
    try {
      final result = await checkInUseCase.call(data);
      await refreshData(); // Refresh list setelah check-in
      return result;
    } catch (e) {
      error.value = 'Gagal check-in: ${e.toString()}';
      Get.snackbar('Error', error.value!);
      return null;
    }
  }

  /// Check-out
  Future<Presensi?> checkOut(String presensiId, Presensi data) async {
    try {
      final result = await checkOutUseCase.call(presensiId, data);
      await refreshData(); // Refresh list setelah check-out
      return result;
    } catch (e) {
      error.value = 'Gagal check-out: ${e.toString()}';
      Get.snackbar('Error', error.value!);
      return null;
    }
  }

  // Helper methods
  void _startLoading() {
    isLoading.value = true;
    error.value = null;
  }

  void _stopLoading() {
    isLoading.value = false;
  }
}
