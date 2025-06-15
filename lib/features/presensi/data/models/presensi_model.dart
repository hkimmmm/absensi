import '../../domain/entities/presensi_entity.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import '../../../../services/presensi_service.dart';

class PresensiModel extends Presensi {
  final int? presensiId; // NEW: for update tracking
  static final logger = Logger();

  PresensiModel({
    this.presensiId,
    super.tanggal,
    super.checkinTime,
    super.checkinLat,
    super.checkinLng,
    super.checkoutTime,
    super.checkoutLat,
    super.checkoutLng,
    required super.status,
  });

  factory PresensiModel.fromJson(Map<String, dynamic> json) {
    print('📥 JSON input: $json');
    return PresensiModel(
      presensiId: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      tanggal: _parseDate(json['tanggal'], 'tanggal'),
      checkinTime: _parseDate(json['checkin_time'], 'checkin_time'),
      checkinLat: _parseDouble(json['checkin_lat'], 'checkin_lat'),
      checkinLng: _parseDouble(json['checkin_lng'], 'checkin_lng'),
      checkoutTime: _parseDate(json['checkout_time'], 'checkout_time'),
      checkoutLat: _parseDouble(json['checkout_lat'], 'checkout_lat'),
      checkoutLng: _parseDouble(json['checkout_lng'], 'checkout_lng'),
      status: json['status']?.toString() ?? 'unknown',
    );
  }

  static DateTime? _parseDate(dynamic value, String fieldName) {
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      print('⚠️ Invalid $fieldName format: $value, error: $e');
      return null;
    }
  }

  static double? _parseDouble(dynamic value, String fieldName) {
    if (value == null) return null;
    try {
      final parsed = double.tryParse(value.toString());
      if (parsed == null || parsed.isNaN || !parsed.isFinite) {
        print('⚠️ Invalid $fieldName: $value');
        return null;
      }
      return parsed;
    } catch (e) {
      print('⚠️ Error parsing $fieldName: $value, error: $e');
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      if (presensiId != null) 'id': presensiId,
      'tanggal':
          tanggal != null ? DateFormat('yyyy-MM-dd').format(tanggal!) : null,
      'checkin_time':
          checkinTime != null ? dateFormat.format(checkinTime!) : null,
      'checkin_lat': checkinLat,
      'checkin_lng': checkinLng,
      'checkout_time':
          checkoutTime != null ? dateFormat.format(checkoutTime!) : null,
      'checkout_lat': checkoutLat,
      'checkout_lng': checkoutLng,
      'status': status,
    };
  }

  Future<Map<String, dynamic>> toCheckoutJson() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return {
        'checkout_time': DateTime.now().toUtc().toIso8601String(),
        'checkout_lat': position.latitude,
        'checkout_lng': position.longitude,
      };
    } catch (e) {
      logger.e('Geolocator error: $e');
      throw PresensiServiceException('Gagal mendapatkan lokasi: $e');
    }
  }

  Presensi toEntity() {
    return Presensi(
      tanggal: tanggal,
      checkinTime: checkinTime,
      checkinLat: checkinLat,
      checkinLng: checkinLng,
      checkoutTime: checkoutTime,
      checkoutLat: checkoutLat,
      checkoutLng: checkoutLng,
      status: status,
    );
  }

  factory PresensiModel.fromEntity(Presensi entity, {int? id}) {
    return PresensiModel(
      presensiId: id,
      tanggal: entity.tanggal,
      checkinTime: entity.checkinTime,
      checkinLat: entity.checkinLat,
      checkinLng: entity.checkinLng,
      checkoutTime: entity.checkoutTime,
      checkoutLat: entity.checkoutLat,
      checkoutLng: entity.checkoutLng,
      status: entity.status,
    );
  }

  factory PresensiModel.forCheckIn({
    required String status,
    double? checkinLat,
    double? checkinLng,
    String? keterangan,
  }) {
    final wibTime = DateTime.now().toUtc().add(const Duration(hours: 7));
    return PresensiModel(
      tanggal: DateTime(wibTime.year, wibTime.month, wibTime.day),
      checkinTime: wibTime,
      checkinLat: checkinLat,
      checkinLng: checkinLng,
      status: status,
    );
  }

  factory PresensiModel.forCheckOut({
    required int presensiId,
    double? checkoutLat,
    double? checkoutLng,
  }) {
    final wibTime = DateTime.now().toUtc().add(const Duration(hours: 7));
    return PresensiModel(
      presensiId: presensiId,
      checkoutTime: wibTime,
      checkoutLat: checkoutLat,
      checkoutLng: checkoutLng,
      status: 'hadir',
    );
  }
}
