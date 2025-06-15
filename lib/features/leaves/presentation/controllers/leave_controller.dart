import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:smartelearn/features/leaves/domain/entities/leave_entity.dart';
import 'package:smartelearn/features/leaves/domain/usecases/apply_leave.dart';
import 'package:smartelearn/features/leaves/domain/usecases/get_leave.dart';

class LeaveController extends GetxController {
  final GetLeaves getLeaves;
  final ApplyLeave applyLeave;

  LeaveController({required this.applyLeave, required this.getLeaves});

  var leaves = <LeaveEntity>[].obs;
  var isLoading = false.obs;
  var error = RxnString();

  // Form state
  var jenis = ''.obs;
  var tanggalMulai = Rxn<DateTime>();
  var tanggalSelesai = Rxn<DateTime>();
  var keterangan = ''.obs;
  var fotoBuktiBase64 = RxnString();

  Future<void> fetchAllLeaves() async {
    _startLoading();
    try {
      final result = await getLeaves();
      leaves.assignAll(result);
      error.value = null;
    } catch (e) {
      error.value = e.toString();
    }
    _stopLoading();
  }

  /// Method untuk mengajukan cuti
  Future<String?> submitLeave() async {
    // Validasi data form
    if (jenis.value.isEmpty ||
        tanggalMulai.value == null ||
        tanggalSelesai.value == null) {
      return 'Lengkapi semua data';
    }

    // Validasi format dan ukuran base64 jika ada
    if (fotoBuktiBase64.value != null) {
      print('Validating base64: ${fotoBuktiBase64.value!.substring(0, 30)}');
      if (!fotoBuktiBase64.value!.startsWith('data:image/jpeg;base64,') &&
          !fotoBuktiBase64.value!.startsWith('data:image/jpg;base64,')) {
        return 'Format gambar tidak valid. Harus JPG/JPEG.';
      }
      // Ambil bagian data base64 (tanpa prefix)
      final base64Data = fotoBuktiBase64.value!.split(',').last;
      // Validasi ukuran (~3.75MB untuk base64, setara ~5MB buffer)
      if (base64Data.length > 3.75 * 1024 * 1024) {
        return 'Ukuran gambar terlalu besar. Maksimum 3.75MB.';
      }
      // Debugging: Log panjang dan awal string
      print('Base64 length: ${fotoBuktiBase64.value!.length}');
      print('Base64 prefix: ${fotoBuktiBase64.value!.substring(0, 30)}');
    }

    final leave = LeaveEntity(
      jenis: jenis.value,
      tanggalMulai: tanggalMulai.value!,
      tanggalSelesai: tanggalSelesai.value!,
      status: 'pending',
      keterangan: keterangan.value,
      fotoBukti: fotoBuktiBase64.value, // Kirim base64
    );

    try {
      _startLoading();
      await applyLeave(leave);
      resetForm();
      return null; // Sukses
    } catch (e) {
      return 'Gagal mengajukan cuti: ${e.toString()}';
    } finally {
      _stopLoading();
    }
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    try {
      final bytes = await image.readAsBytes();
      print('Image bytes length: ${bytes.length}');

      // Check JPEG header bytes first for more reliable validation
      bool isJpeg = bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xD8;
      if (!isJpeg) {
        // Additional check for JFIF or other JPEG variants
        final decodedImage = img.decodeImage(bytes);
        if (decodedImage == null ||
            !decodedImage.format.toString().contains('Jpeg')) {
          error.value = 'Hanya file JPG/JPEG yang diizinkan';
          return;
        }
      }

      // Get extension for logging (optional)
      String extension = '';
      if (kIsWeb) {
        extension = image.name.isNotEmpty
            ? image.name.toLowerCase().split('.').last
            : 'unknown';
      } else {
        extension = image.path.isNotEmpty
            ? image.path.toLowerCase().split('.').last
            : 'unknown';
      }
      print('Image name: ${image.name}');
      print('Image path: ${image.path}');
      print('Image extension: $extension');

      // Resize and compress image
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) {
        error.value = 'Gagal memproses gambar: Gambar tidak valid';
        return;
      }

      final resizedImage = img.copyResize(originalImage, width: 480);
      final resizedBytes = img.encodeJpg(resizedImage, quality: 60);
      print('Resized bytes length: ${resizedBytes.length}');

      // Validate size after compression (< 2.8MB binary, ~3.75MB base64)
      if (resizedBytes.length > 2.8 * 1024 * 1024) {
        error.value = 'Gambar terlalu besar setelah kompresi (maks 2.8MB)';
        return;
      }

      // Generate base64 string
      final base64String =
          'data:image/jpeg;base64,${base64Encode(resizedBytes)}';
      fotoBuktiBase64.value = base64String;

      // Debugging
      print('Base64 prefix: ${base64String.substring(0, 30)}');
      print('Base64 length: ${base64String.length}');
    } catch (e) {
      error.value = 'Gagal memuat: $e';
      print('Error in pickImageFromGallery: $e');
    }
  }

  /// Reset form cuti ke kondisi awal
  void resetForm() {
    jenis.value = '';
    tanggalMulai.value = null;
    tanggalSelesai.value = null;
    keterangan.value = '';
    fotoBuktiBase64.value = null;
  }

  void _startLoading() {
    isLoading.value = true;
    error.value = null;
  }

  void _stopLoading() {
    isLoading.value = false;
  }
}
