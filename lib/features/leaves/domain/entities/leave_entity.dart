class LeaveEntity {
  final int? id;
  final String jenis; // Nullable
  final DateTime tanggalMulai; // Nullable
  final DateTime tanggalSelesai; // Nullable
  final String status; // Nullable
  final String? keterangan;
  final String? fotoBukti;
  final int? approvedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? karyawanNama;
  final String? approverUsername;

  LeaveEntity({
    this.id,
    required this.jenis,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.status,
    this.keterangan,
    this.fotoBukti,
    this.approvedBy,
    this.createdAt,
    this.updatedAt,
    this.karyawanNama,
    this.approverUsername,
  });

  bool get isUpcoming => tanggalMulai.isAfter(DateTime.now());
  bool get isPast => tanggalSelesai.isBefore(DateTime.now());

  bool get isOngoing =>
      !isPast &&
      !isUpcoming &&
      (tanggalMulai.isBefore(DateTime.now())) &&
      (tanggalSelesai.isAfter(DateTime.now()));
}
