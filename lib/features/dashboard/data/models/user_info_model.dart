import '../../domain/entities/user_info_entity.dart';

class UserInfoModel extends UserInfoEntity {
  UserInfoModel({
    required super.nama,
    required super.role,
    required super.fotoProfile,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      nama: json['nama'] ?? '',
      role: json['role'] ?? '',
      fotoProfile: json['foto_profile'] as String? ?? '',
    );
  }

  UserInfoEntity toEntity() {
    return UserInfoEntity(
      nama: nama,
      role: role,
      fotoProfile: fotoProfile,
    );
  }
}
