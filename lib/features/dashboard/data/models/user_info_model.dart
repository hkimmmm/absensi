import '../../domain/entities/user_info_entity.dart';

class UserInfoModel extends UserInfoEntity {
  UserInfoModel({
    required super.fotoProfile,
    required super.nik,
    required super.nama,
    required super.email,
    required super.noTelp,
    required super.alamat,
    required super.role,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      fotoProfile: json['foto_profile'] as String? ?? '',
      nik: json['nik'] as String? ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      noTelp: json['no_telepon'] ?? '',
      alamat: json['alamat'] ?? '',
      role: json['role'] ?? '',
    );
  }

  UserInfoEntity toEntity() {
    return UserInfoEntity(
      fotoProfile: fotoProfile,
      nik: nik,
      nama: nama,
      email: email,
      noTelp: noTelp,
      alamat: alamat,
      role: role,
    );
  }
}
