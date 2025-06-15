import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
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

  const UserEntity({
    required this.id,
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

  @override
  List<Object?> get props => [
        id,
        username,
        karyawanId,
        nama,
        email,
        role,
        nik,
        fotoProfile,
        noTelepon,
        status,
        tanggalBergabung,
        token,
      ];
}
