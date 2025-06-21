import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:smartelearn/services/presensi_service.dart';
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
      print("Presensi list: ${data.map((e) => {
            'id': e.id,
            'tanggal': e.tanggal?.toString(),
            'checkinTime': e.checkinTime?.toString(),
            'checkoutTime': e.checkoutTime?.toString(),
            'status': e.status
          }).toList()}");
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
    print("Refreshing presensi data...");
    await loadPresensi();
  }

  Future<Presensi?> checkIn(Presensi data) async {
    print('📥 Controller: checkIn called with data: $data');
    try {
      if (data.batchId == null) {
        throw PresensiValidationException('batchId wajib diisi');
      }
      if (data.status == 'hadir' &&
          (data.checkinLat == null || data.checkinLng == null)) {
        throw PresensiValidationException('Lokasi wajib untuk status hadir');
      }
      final result = await checkInUseCase.call(data);
      print('✅ Controller: checkIn successful, result: $result');
      await refreshData();
      return result;
    } catch (e, stackTrace) {
      error.value =
          e is PresensiValidationException || e is PresensiServiceException
              ? e.toString()
              : 'Gagal check-in: ${e.toString()}';
      print('❌ Controller: checkIn failed: $e, StackTrace: $stackTrace');
      Get.snackbar('Error', error.value!, duration: Duration(seconds: 5));
      return null;
    }
  }

  Future<Presensi?> checkOut(Presensi data) async {
    try {
      if (data.batchId == null) {
        throw PresensiValidationException('batchId wajib diisi');
      }
      if (data.status == 'hadir' &&
          (data.checkoutLat == null || data.checkoutLng == null)) {
        throw PresensiValidationException('Lokasi wajib untuk status hadir');
      }
      final result = await checkOutUseCase.call(data);
      await refreshData();
      Get.snackbar('Sukses', 'Check-out berhasil');
      return result;
    } catch (e, stackTrace) {
      String errorMessage;
      if (e is PresensiValidationException || e is PresensiServiceException) {
        errorMessage = e
            .toString()
            .replaceAll('PresensiValidationException: ', '')
            .replaceAll('PresensiServiceException: ', '');
        if (errorMessage.contains('Tidak ada presensi aktif untuk hari ini')) {
          errorMessage =
              'Tidak ada presensi aktif hari ini. Silakan check-in terlebih dahulu.';
        }
      } else if (e is UnauthorizedException) {
        errorMessage = 'Akses tidak diizinkan. Silakan login ulang.';
      } else {
        errorMessage = 'Gagal check-out: ${e.toString()}';
      }
      error.value = errorMessage;
      Logger().e('Controller: checkOut failed: $e, StackTrace: $stackTrace');
      Get.snackbar('Error', errorMessage, duration: Duration(seconds: 5));
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

  bool get hasActivePresensiToday {
    final now = DateTime.now().toLocal(); // Ensure local time
    final result = presensiList.any((presensi) {
      if (presensi.checkoutTime != null || presensi.tanggal == null) {
        return false;
      }
      final presensiDate = presensi.tanggal!.toLocal(); // Convert to local time
      final isToday = isSameDay(presensiDate, now);
      print(
          'Presensi: id=${presensi.id}, tanggal=$presensiDate, checkoutTime=${presensi.checkoutTime}, IsToday: $isToday');
      return isToday;
    });
    print('hasActivePresensiToday: $result');
    return result;
  }

  bool get hasPendingCheckoutFromPreviousDay {
    final now = DateTime.now().toLocal();
    return presensiList.any((presensi) {
      if (presensi.checkoutTime != null || presensi.tanggal == null) {
        return false;
      }
      final presensiDate = presensi.tanggal!.toLocal();
      return !isSameDay(presensiDate, now);
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
