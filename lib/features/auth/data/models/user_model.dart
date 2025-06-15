import '../../domain/entities/user_entity.dart';

class UserModel {
  final int userId;
  final String username;
  final int? karyawanId;
  final String nama;
  final String email;
  final String role;
  final String? nik;
  final String? fotoProfile;
  final String? noTelepon;
  final String? status;
  final DateTime? tanggalBergabung;
  final String? token;

  UserModel({
    required this.userId,
    required this.username,
    this.karyawanId,
    required this.nama,
    required this.email,
    required this.role,
    this.nik,
    this.fotoProfile,
    this.noTelepon,
    this.status,
    this.tanggalBergabung,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json['user_id'] == null) {
      throw Exception('Field "user_id" tidak boleh null');
    }

    return UserModel(
      userId: json['user_id'] as int,
      username: json['username'] ?? '',
      karyawanId: json['karyawan_id'] as int?,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      nik: json['nik'] as String?,
      fotoProfile: json['foto_profile'] as String?,
      noTelepon: json['no_telepon'] as String?,
      status: json['status'] as String?,
      tanggalBergabung: json['tanggal_bergabung'] != null
          ? DateTime.tryParse(json['tanggal_bergabung'])
          : null,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'karyawan_id': karyawanId,
      'nama': nama,
      'email': email,
      'role': role,
      'nik': nik,
      'foto_profile': fotoProfile,
      'no_telepon': noTelepon,
      'status': status,
      'tanggal_bergabung': tanggalBergabung?.toIso8601String(),
      'token': token,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: userId,
      username: username,
      karyawanId: karyawanId,
      nama: nama,
      email: email,
      role: role,
      nik: nik,
      fotoProfile: fotoProfile,
      noTelepon: noTelepon,
      status: status,
      tanggalBergabung: tanggalBergabung,
      token: token,
    );
  }
}
