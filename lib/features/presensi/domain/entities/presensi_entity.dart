class Presensi {
  final String? id; // Tambahan ID
  final DateTime? tanggal;
  final DateTime? checkinTime;
  final double? checkinLat;
  final double? checkinLng;
  final DateTime? checkoutTime;
  final double? checkoutLat;
  final double? checkoutLng;
  final String status;

  Presensi({
    this.id,
    this.tanggal,
    this.checkinTime,
    this.checkinLat,
    this.checkinLng,
    this.checkoutTime,
    this.checkoutLat,
    this.checkoutLng,
    required this.status,
  });

  factory Presensi.forCheckIn({
    required String status,
    double? checkinLat,
    double? checkinLng,
  }) {
    final wibTime = DateTime.now().toUtc().add(const Duration(hours: 7));
    return Presensi(
      tanggal: DateTime(wibTime.year, wibTime.month, wibTime.day),
      checkinTime: wibTime,
      checkinLat: checkinLat,
      checkinLng: checkinLng,
      status: status,
    );
  }
}
