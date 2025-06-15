import '../../domain/entities/leave_entity.dart';

class LeaveModel extends LeaveEntity {
  LeaveModel({
    required int super.id,
    required super.jenis, // Nullable
    required super.tanggalMulai, // Nullable
    required super.tanggalSelesai, // Nullable
    required super.status, // Nullable
    super.keterangan,
    super.fotoBukti,
    super.approvedBy,
    super.createdAt,
    super.updatedAt,
    super.karyawanNama,
    super.approverUsername,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw Exception('Field "id" tidak boleh null');
    }
    return LeaveModel(
      id: json['id'],
      jenis: json['jenis'],
      tanggalMulai: json['tanggal_mulai'] != null
          ? DateTime.parse(json['tanggal_mulai'])
          : DateTime.now(),
      tanggalSelesai: json['tanggal_selesai'] != null
          ? DateTime.parse(json['tanggal_selesai'])
          : DateTime.now(),
      status: json['status'],
      keterangan: json['keterangan'],
      fotoBukti: json['foto_bukti'],
      approvedBy: json['approved_by'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      karyawanNama: json['karyawan_nama'],
      approverUsername: json['approver_username'],
    );
  }

  factory LeaveModel.fromEntity(LeaveEntity entity) {
    return LeaveModel(
      id: entity.id ?? 0,
      jenis: entity.jenis,
      tanggalMulai: entity.tanggalMulai,
      tanggalSelesai: entity.tanggalSelesai,
      status: entity.status,
      keterangan: entity.keterangan,
      fotoBukti: entity.fotoBukti,
      approvedBy: entity.approvedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      karyawanNama: entity.karyawanNama,
      approverUsername: entity.approverUsername,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jenis': jenis,
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_selesai': tanggalSelesai.toIso8601String(),
      'status': status,
      'keterangan': keterangan,
      'foto_bukti': fotoBukti,
      'approved_by': approvedBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'karyawan_nama': karyawanNama,
      'approver_username': approverUsername,
    };
  }
}
