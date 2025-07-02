import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartelearn/services/presensi_service.dart';
import 'dart:convert';
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
  if (_isProcessing) return;
  setState(() {
    _isProcessing = true;
  });

  final controller = Get.find<PresensiController>();
  print('📥 Controller instance: $controller');

  Position? position = await LocationHelper.getCurrentLocation();
  if (position == null) {
    Get.snackbar(
      "Gagal",
      "Lokasi tidak aktif atau tidak diizinkan.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 5),
      snackPosition: SnackPosition.TOP,
      onTap: (_) => print('📥 Failure snackbar tapped'),
    );
    setState(() {
      _isProcessing = false;
    });
    return;
  }

  try {
    // Dekode base64
    final decoded = utf8.decode(base64Decode(code));
    final qrData = jsonDecode(decoded) as Map<String, dynamic>;
    final batchId = qrData['batchId']?.toString();
    if (batchId == null) {
      throw PresensiValidationException('batchId tidak ditemukan di QR code');
    }

    final presensi = Presensi(
      checkinLat: position.latitude,
      checkinLng: position.longitude,
      status: 'hadir',
      batchId: batchId,
    );
    print('📥 Presensi data: $presensi');

    final result = await controller.checkIn(presensi);
    print(
        '📥 Check-in result: $result, Type: ${result.runtimeType}, Fields: id=${result?.id}, tanggal=${result?.tanggal}, status=${result?.status}');
    if (result != null) {
      print('✅ Triggering success snackbar');
      Get.snackbar(
        "Sukses",
        "Check-in berhasil",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
        onTap: (_) => print('📥 Success snackbar tapped'),
        isDismissible: true,
      );
      await Future.delayed(Duration(seconds: 5));
      print('📥 Navigating back');
      Get.back();
    } else {
      print('❌ Check-in result is null');
      // Gunakan error.value dari controller untuk pesan spesifik
      String? errorMessage = controller.error.value!.isNotEmpty
          ? controller.error.value
          : 'Check-in gagal';
      // Hilangkan prefiks "Exception: Gagal Check-in:" jika ada
      if (errorMessage!.startsWith('Exception: Gagal Check-in: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: Gagal Check-in: ', '');
      } else if (errorMessage.startsWith('Gagal Check-in: ')) {
        errorMessage = errorMessage.replaceFirst('Gagal Check-in: ', '');
      }
      Get.snackbar(
        "Gagal",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
        onTap: (_) => print('📥 Failure snackbar tapped'),
      );
    }
  } catch (e, stackTrace) {
    print('❌ Error scan QR: $e, StackTrace: $stackTrace');
    String errorMessage = e.toString();
    // Hilangkan prefiks "Exception: Gagal Check-in:" jika ada
    if (errorMessage.startsWith('Exception: Gagal Check-in: ')) {
      errorMessage = errorMessage.replaceFirst('Exception: Gagal Check-in: ', '');
    } else if (errorMessage.startsWith('Gagal Check-in: ')) {
      errorMessage = errorMessage.replaceFirst('Gagal Check-in: ', '');
    }
    Get.snackbar(
      "Gagal",
      errorMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 5),
      snackPosition: SnackPosition.TOP,
      onTap: (_) => print('📥 Error snackbar tapped'),
    );
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
