import 'package:dart_mappable/dart_mappable.dart';

part 'user_model.mapper.dart';

@MappableClass()
class UserModel with UserModelMappable {
  final int id;
  final String name;
  final String email;
  final String deviceId;
  final String? createdAt;
  final String? updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.deviceId,
    this.createdAt,
    this.updatedAt,
  });

  static const fromMap = UserModelMapper.fromMap;
  static const fromJson = UserModelMapper.fromJson;
}

@MappableClass()
class UpdateProfileRequest with UpdateProfileRequestMappable {
  final int? id;
  final String? name;
  final String? email;
  final String? deviceId;
  final String? password;

  const UpdateProfileRequest({
    this.id,
    this.name,
    this.email,
    this.deviceId,
    this.password,
  });

  static const fromMap = UpdateProfileRequestMapper.fromMap;
  static const fromJson = UpdateProfileRequestMapper.fromJson;
}
