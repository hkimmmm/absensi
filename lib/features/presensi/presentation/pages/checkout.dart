import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/presensi_controller.dart';
import '../../../../utils/location_helper.dart';
import '../../../presensi/data/models/presensi_model.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = false.obs; // Observable untuk status loading

    // ignore: no_leading_underscores_for_local_identifiers
    void _handleScan(String code) async {
      isLoading.value = true; // Tampilkan loading

      final controller = Get.find<PresensiController>();

      // Ambil lokasi
      Position? position = await LocationHelper.getCurrentLocation();

      if (position == null) {
        isLoading.value = false;
        Get.snackbar("Gagal", "Lokasi tidak aktif atau tidak diizinkan.",
            backgroundColor: Colors.red, colorText: Colors.white);
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
        return;
      }

      try {
        final now = DateTime.now();

        // Buat instance PresensiModel, dengan data check-out
        final presensi = PresensiModel(
          checkoutTime: now,
          checkoutLat: position.latitude,
          checkoutLng: position.longitude,
          status: 'hadir', // bisa diubah sesuai kebutuhan
        );

        final result = await controller.checkOut(code, presensi);

        isLoading.value = false;

        if (result != null) {
          Get.snackbar("Sukses", "Check-out berhasil",
              backgroundColor: Colors.green, colorText: Colors.white);
          await Future.delayed(const Duration(seconds: 1));
          Get.back();
        } else {
          Get.snackbar("Gagal", "Tidak dapat menyelesaikan check-out.",
              backgroundColor: Colors.red, colorText: Colors.white);
          await Future.delayed(const Duration(seconds: 2));
          Get.back();
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Error", e.toString(),
            backgroundColor: Colors.red, colorText: Colors.white);
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Scan QR Check-Out'),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: MobileScannerController(
              facing: CameraFacing.back,
              torchEnabled: false,
            ),
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              final code = barcode.rawValue;
              if (code != null && !isLoading.value) {
                _handleScan(code);
              }
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Pastikan lokasi (GPS) aktif untuk Check-Out',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Obx(() => isLoading.value
              ? Container(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox()),
        ],
      ),
    );
  }
}
