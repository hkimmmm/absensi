// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:smartelearn/features/presensi/presentation/controllers/presensi_controller.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class QrCodeScreen extends StatefulWidget {
//   const QrCodeScreen({super.key});

//   @override
//   State<QrCodeScreen> createState() => _QrCodeScreenState();
// }

// class _QrCodeScreenState extends State<QrCodeScreen> {
//   final PresensiController controller = Get.find<PresensiController>();
//   bool isProcessing = false;
//   bool? isCheckIn;
//   bool _locationEnabled = false;
//   bool _isConnected = true;
//   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

//   @override
//   void initState() {
//     super.initState();
//     _checkLocationService();
//     _initConnectivity();
//     _connectivitySubscription =
//         Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
//   }

//   @override
//   void dispose() {
//     _connectivitySubscription.cancel();
//     super.dispose();
//   }

//   Future<void> _initConnectivity() async {
//     final result = await Connectivity().checkConnectivity();
//     _updateConnectionStatus(result);
//   }

//   void _updateConnectionStatus(List<ConnectivityResult> results) {
//     setState(() {
//       _isConnected = results.isNotEmpty && results.first != ConnectivityResult.none;
//     });
//   }

//   Future<void> _checkLocationService() async {
//     final enabled = await Geolocator.isLocationServiceEnabled();
//     setState(() {
//       _locationEnabled = enabled;
//     });

//     if (!enabled) {
//       await _showLocationDialog(
//         'Layanan lokasi tidak aktif',
//         'Mohon aktifkan lokasi untuk dapat melakukan presensi.',
//       );
//     }
//   }

//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await _showLocationDialog(
//         'Layanan lokasi tidak aktif',
//         'Mohon aktifkan lokasi untuk dapat melakukan presensi.',
//       );
//       return false;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         await _showLocationDialog(
//           'Izin lokasi ditolak',
//           'Anda perlu memberikan izin lokasi untuk melakukan presensi.',
//         );
//         return false;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       await _showLocationDialog(
//         'Izin lokasi ditolak permanen',
//         'Silakan berikan izin lokasi melalui pengaturan perangkat.',
//       );
//       return false;
//     }
//     return true;
//   }

//   Future<void> _showLocationDialog(String title, String message) async {
//     if (!mounted) return;
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         title: Text(title, style: const TextStyle(color: Colors.blue)),
//         content: Text(message, style: const TextStyle(color: Colors.blue)),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK', style: TextStyle(color: Colors.blue)),
//           ),
//           if (title.contains('tidak aktif'))
//             TextButton(
//               onPressed: () async {
//                 await Geolocator.openLocationSettings();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Buka Pengaturan',
//                   style: TextStyle(color: Colors.blue)),
//             ),
//         ],
//       ),
//     );
//   }

//   void _onDetect(BarcodeCapture capture) async {
//     if (isProcessing || isCheckIn == null || !_isConnected) return;

//     final Barcode? barcode = capture.barcodes.firstOrNull;
//     final String? code = barcode?.rawValue;
//     if (code == null) return;

//     setState(() => isProcessing = true);

//     try {
//       final hasPermission = await _handleLocationPermission();
//       if (!hasPermission) {
//         setState(() => isProcessing = false);
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       ).timeout(const Duration(seconds: 10));

//       final presensiId = code;
//       final now = DateTime.now();

//       final data = {
//         'presensiId': presensiId,
//         'tanggal': now.toIso8601String().split('T').first,
//         'status': 'hadir',
//         if (isCheckIn!) ...{
//           'checkin_time': now.toIso8601String(),
//           'checkin_lat': position.latitude.toString(),
//           'checkin_lng': position.longitude.toString(),
//         } else ...{
//           'checkout_time': now.toIso8601String(),
//           'checkout_lat': position.latitude.toString(),
//           'checkout_lng': position.longitude.toString(),
//         },
//       };

//       if (isCheckIn!) {
//         await controller.checkIn(data);
//       } else {
//         await controller.checkOut(presensiId, data);
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.blue,
//             content: Text(
//               '${isCheckIn! ? 'Check-in' : 'Check-out'} sukses',
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         );
//         Navigator.of(context).pop();
//       }
//     } on TimeoutException {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.red,
//             content: Text(
//               'Timeout: Gagal mendapatkan lokasi',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.red,
//             content: Text(
//               'Gagal ${isCheckIn! ? 'check-in' : 'check-out'}: ${e.toString()}',
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => isProcessing = false);
//     }
//   }

//   Widget _buildSelectionScreen() {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.white, Colors.blue],
//         ),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (!_locationEnabled)
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.amber[100],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.orange),
//                 ),
//                 child: const Text(
//                   '⚠️ Aktifkan lokasi untuk presensi',
//                   style: TextStyle(color: Colors.orange),
//                 ),
//               ),
//             if (!_isConnected)
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.red[100],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.red),
//                 ),
//                 child: const Text(
//                   '⚠️ Tidak ada koneksi internet',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             const Text(
//               'Pilih Jenis Presensi',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: 200,
//               child: ElevatedButton(
//                 onPressed: () => setState(() => isCheckIn = true),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'CHECK-IN',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             SizedBox(
//               width: 200,
//               child: ElevatedButton(
//                 onPressed: () => setState(() => isCheckIn = false),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'CHECK-OUT',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildScannerScreen() {
//     return Stack(
//       children: [
//         MobileScanner(
//           onDetect: _onDetect,
//           controller: MobileScannerController(
//             detectionSpeed: DetectionSpeed.normal,
//             facing: CameraFacing.back,
//             torchEnabled: false,
//           ),
//         ),
//         Center(
//           child: Container(
//             width: 200,
//             height: 200,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.white,
//                 width: 2,
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 50,
//           left: 20,
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
//             onPressed: () => setState(() => isCheckIn = null),
//           ),
//         ),
//         Positioned(
//           bottom: 30,
//           left: 0,
//           right: 0,
//           child: Column(
//             children: [
//               Text(
//                 isCheckIn! ? 'Scan QR Check-in' : 'Scan QR Check-out',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               if (!_isConnected)
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: const Text(
//                     'Tidak ada koneksi internet',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         if (isProcessing)
//           const Center(
//             child: CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 5,
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isCheckIn == null ? _buildSelectionScreen() : _buildScannerScreen(),
//     );
//   }
// }
