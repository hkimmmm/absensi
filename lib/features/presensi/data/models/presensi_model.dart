import '../../domain/entities/presensi_entity.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class PresensiModel extends Presensi {
  static final logger = Logger();

  PresensiModel({
    super.id,
    super.tanggal,
    super.checkinTime,
    super.checkinLat,
    super.checkinLng,
    super.checkoutTime,
    super.checkoutLat,
    super.checkoutLng,
    super.status,
    super.batchId,
    super.presensiId,
    super.type,
  });

  factory PresensiModel.fromJson(Map<String, dynamic> json) {
    logger.d('📥 JSON input: $json');
    return PresensiModel(
      id: json['id']?.toString(),
      tanggal: _parseDate(json['tanggal'], 'tanggal'),
      checkinTime: _parseDate(json['checkin_time'], 'checkin_time'),
      checkinLat: _parseDouble(json['checkin_lat'], 'checkin_lat'),
      checkinLng: _parseDouble(json['checkin_lng'], 'checkin_lng'),
      checkoutTime: _parseDate(json['checkout_time'], 'checkout_time'),
      checkoutLat: _parseDouble(json['checkout_lat'], 'checkout_lat'),
      checkoutLng: _parseDouble(json['checkout_lng'], 'checkout_lng'),
      status: json['status']?.toString(),
      batchId: json['batchId']?.toString(),
      presensiId: json['presensiId']?.toString(),
      type: json['type']?.toString(),
    );
  }

  static DateTime? _parseDate(dynamic value, String fieldName) {
    if (value == null) {
      logger.w('⚠️ $fieldName is null');
      return null;
    }
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      logger.e('⚠️ Invalid $fieldName format: $value, error: $e');
      return null;
    }
  }

  static double? _parseDouble(dynamic value, String fieldName) {
    if (value == null) {
      logger.w('⚠️ $fieldName is null');
      return null;
    }
    try {
      final parsed = double.tryParse(value.toString());
      if (parsed == null || parsed.isNaN || !parsed.isFinite) {
        logger.w('⚠️ Invalid $fieldName: $value');
        return null;
      }
      return parsed;
    } catch (e) {
      logger.e('⚠️ Error parsing $fieldName: $value, error: $e');
      return null;
    }
  }

  Map<String, dynamic> toJson({String? type}) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      if (id != null) 'id': id,
      if (tanggal != null) 'tanggal': tanggal!.toIso8601String().split('T')[0],
      if (checkinTime != null) 'checkin_time': dateFormat.format(checkinTime!),
      if (checkinLat != null) 'checkin_lat': checkinLat,
      if (checkinLng != null) 'checkin_lng': checkinLng,
      if (checkoutTime != null)
        'checkout_time': dateFormat.format(checkoutTime!),
      if (checkoutLat != null) 'checkout_lat': checkoutLat,
      if (checkoutLng != null) 'checkout_lng': checkoutLng,
      if (batchId != null) 'batchId': batchId,
      if (presensiId != null) 'presensiId': presensiId,
      'type': type ?? this.type ?? 'checkin',
    };
  }

  Presensi toEntity() {
    return Presensi(
      id: id,
      tanggal: tanggal,
      checkinTime: checkinTime,
      checkinLat: checkinLat,
      checkinLng: checkinLng,
      checkoutTime: checkoutTime,
      checkoutLat: checkoutLat,
      checkoutLng: checkoutLng,
      status: status,
      batchId: batchId,
      presensiId: presensiId,
      type: type,
    );
  }

  factory PresensiModel.fromEntity(Presensi entity) {
    return PresensiModel(
      id: entity.id,
      tanggal: entity.tanggal,
      checkinTime: entity.checkinTime,
      checkinLat: entity.checkinLat,
      checkinLng: entity.checkinLng,
      checkoutTime: entity.checkoutTime,
      checkoutLat: entity.checkoutLat,
      checkoutLng: entity.checkoutLng,
      status: entity.status,
      batchId: entity.batchId,
      presensiId: entity.presensiId,
      type: entity.type,
    );
  }

  factory PresensiModel.forCheckIn({
    required String status,
    required String batchId,
    double? checkinLat,
    double? checkinLng,
  }) {
    const validStatuses = ['hadir', 'izin', 'sakit'];
    if (!validStatuses.contains(status.toLowerCase())) {
      logger.w(
          '⚠️ Status tidak valid: $status. Harus salah satu dari $validStatuses');
    }
    if (status.toLowerCase() == 'hadir' &&
        (checkinLat == null || checkinLng == null)) {
      logger.w(
          '⚠️ Lokasi (checkinLat, checkinLng) wajib diisi untuk status "hadir"');
    }
    final wibTime = DateTime.now().toUtc().add(const Duration(hours: 7));
    return PresensiModel(
      tanggal: DateTime(wibTime.year, wibTime.month, wibTime.day),
      checkinTime: wibTime,
      checkinLat: checkinLat,
      checkinLng: checkinLng,
      status: status,
      batchId: batchId,
      type: 'checkin', // Tambahkan field type di PresensiModel
    );
  }

  factory PresensiModel.forCheckOut({
    required String batchId,
    double? checkoutLat,
    double? checkoutLng,
    String? presensiId,
  }) {
    final wibTime = DateTime.now().toUtc().add(const Duration(hours: 7));
    return PresensiModel(
      tanggal: DateTime(wibTime.year, wibTime.month, wibTime.day),
      checkoutTime: wibTime,
      checkoutLat: checkoutLat,
      checkoutLng: checkoutLng,
      batchId: batchId,
      presensiId: presensiId,
    );
  }
}
