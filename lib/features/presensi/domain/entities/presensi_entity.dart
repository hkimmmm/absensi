class Presensi {
  final String? id;
  final DateTime? tanggal;
  final DateTime? checkinTime;
  final double? checkinLat;
  final double? checkinLng;
  final DateTime? checkoutTime;
  final double? checkoutLat;
  final double? checkoutLng;
  final String? status; // Ubah menjadi opsional
  final String? batchId;
  final String? presensiId; // Tambahkan untuk QR perorangan
  final String? type;

  Presensi({
    this.id,
    this.tanggal,
    this.checkinTime,
    this.checkinLat,
    this.checkinLng,
    this.checkoutTime,
    this.checkoutLat,
    this.checkoutLng,
    this.status,
    this.batchId,
    this.presensiId,
    this.type,
  });

  factory Presensi.forCheckIn({
    required String status,
    double? checkinLat,
    double? checkinLng,
    required String batchId,
  }) {
    final wibTime = DateTime.now().toUtc().add(const Duration(hours: 7));
    return Presensi(
      tanggal: DateTime(wibTime.year, wibTime.month, wibTime.day),
      checkinTime: wibTime,
      checkinLat: checkinLat,
      checkinLng: checkinLng,
      status: status,
      batchId: batchId,
    );
  }

  factory Presensi.forCheckOut({
    double? checkoutLat,
    double? checkoutLng,
    required String batchId,
    String? presensiId,
  }) {
    final wibTime = DateTime.now().toUtc().add(const Duration(hours: 7));
    return Presensi(
      tanggal: DateTime(wibTime.year, wibTime.month, wibTime.day),
      checkoutTime: wibTime,
      checkoutLat: checkoutLat,
      checkoutLng: checkoutLng,
      batchId: batchId,
      presensiId: presensiId,
    );
  }
}
