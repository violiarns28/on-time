import 'package:dart_mappable/dart_mappable.dart';
import 'package:on_time/data/models/user_model.dart';

part 'auth_model.mapper.dart';

@MappableClass()
abstract class LoginRequest with LoginRequestMappable {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  static const fromMap = LoginRequestMapper.fromMap;
  static const fromJson = LoginRequestMapper.fromJson;
}

@MappableClass()
abstract class LoginResponse with LoginResponseMappable {
  final UserModel user;
  final String token;
  const LoginResponse({
    required this.user,
    required this.token,
  });

  static const fromMap = LoginResponseMapper.fromMap;
  static const fromJson = LoginResponseMapper.fromJson;
}

@MappableClass()
abstract class RegisterRequest with RegisterRequestMappable {
  final String email;
  final String password;
  final String name;
  final String deviceId;
  const RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.deviceId,
  });

  static const fromMap = RegisterRequestMapper.fromMap;
  static const fromJson = RegisterRequestMapper.fromJson;
}

@MappableClass()
abstract class RegisterResponse with RegisterResponseMappable {
  final UserModel user;
  final String token;
  const RegisterResponse({
    required this.user,
    required this.token,
  });

  static const fromMap = RegisterResponseMapper.fromMap;
  static const fromJson = RegisterResponseMapper.fromJson;
}
