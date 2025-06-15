import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/presensi_controller.dart';
import '../../../../utils/location_helper.dart';
import '../../domain/entities/presensi_entity.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  bool _isProcessing = false;

  void _handleScan(String code) async {
    if (_isProcessing) return; // Prevent multiple scans
    setState(() {
      _isProcessing = true;
    });

    final controller = Get.find<PresensiController>();

    Position? position = await LocationHelper.getCurrentLocation();

    if (position == null) {
      Get.snackbar("Gagal", "Lokasi tidak aktif atau tidak diizinkan.",
          backgroundColor: Colors.red, colorText: Colors.white);
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    try {
      final presensi = Presensi(
        checkinLat: position.latitude,
        checkinLng: position.longitude,
        status: 'hadir',
      );

      final result = await controller.checkIn(presensi);

      if (result != null) {
        Get.snackbar("Sukses", "Check-in berhasil",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.back(); // Navigate back after successful check-in
      } else {
        Get.snackbar("Gagal", "Check-in gagal",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Scan QR Check-In'),
        centerTitle: true,
        backgroundColor: Colors.blue,
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
              if (_isProcessing) return; // Prevent scan during processing
              final barcode = capture.barcodes.first;
              final code = barcode.rawValue;
              if (code != null) {
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
                'Pastikan lokasi (GPS) aktif untuk Check-In',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Add loading indicator when _isProcessing is true
          if (_isProcessing)
            Container(
              color: Colors.black54, // Semi-transparent background
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
