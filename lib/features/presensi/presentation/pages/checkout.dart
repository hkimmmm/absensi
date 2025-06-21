import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartelearn/services/presensi_service.dart';
import '../controllers/presensi_controller.dart';
import '../../../../utils/location_helper.dart';
import '../../../presensi/data/models/presensi_model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final MobileScannerController _scannerController = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool _isProcessing = false;

  Future<void> _handleScan(String code) async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    final controller = Get.find<PresensiController>();

    try {
      // Get current location
      Position? position = await LocationHelper.getCurrentLocation();
      if (position == null) {
        throw Exception('Lokasi tidak aktif atau tidak diizinkan.');
      }

      // Decode QR code
      final decoded = utf8.decode(base64Decode(code));
      final qrData = jsonDecode(decoded) as Map<String, dynamic>;
      final batchId = qrData['batchId']?.toString();
      final presensiId = qrData['token']?.toString();
      final qrType = qrData['type']?.toString();

      // Validate QR type
      if (qrType != 'checkout') {
        throw PresensiValidationException('QR code bukan untuk check-out');
      }

      // Validate QR data
      if (batchId == null && presensiId == null) {
        throw PresensiValidationException(
            'batchId atau presensiId tidak ditemukan di QR code');
      }

      // Check QR code expiration for mass QR
      if (batchId != null) {
        final expiresAt = DateTime.parse(qrData['expiresAt']?.toString() ?? '');
        if (expiresAt.isBefore(DateTime.now())) {
          throw PresensiValidationException('QR code telah kedaluwarsa');
        }
      }

      // Create Presensi entity
      final presensi = PresensiModel.forCheckOut(
        batchId: batchId ?? '-',
        presensiId: presensiId,
        checkoutLat: position.latitude,
        checkoutLng: position.longitude,
      );

      // Perform check-out
      final result = await controller.checkOut(presensi.toEntity());
      if (result != null) {
        Get.snackbar(
          'Sukses',
          'Check-out berhasil',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
        Get.back();
      } else {
        throw Exception('Check-out gagal');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e is PresensiValidationException
            ? e.toString().replaceAll('PresensiValidationException: ', '')
            : 'Gagal memproses check-out: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
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
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            controller: _scannerController,
            onDetect: (capture) {
              if (_isProcessing) return;
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
                'Pastikan lokasi (GPS) aktif untuk Check-Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
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
