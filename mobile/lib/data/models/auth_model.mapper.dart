// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_model.dart';

class LoginRequestMapper extends ClassMapperBase<LoginRequest> {
  LoginRequestMapper._();

  static LoginRequestMapper? _instance;
  static LoginRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LoginRequest';

  static String _$email(LoginRequest v) => v.email;
  static const Field<LoginRequest, String> _f$email = Field('email', _$email);
  static String _$password(LoginRequest v) => v.password;
  static const Field<LoginRequest, String> _f$password =
      Field('password', _$password);

  @override
  final MappableFields<LoginRequest> fields = const {
    #email: _f$email,
    #password: _f$password,
  };

  static LoginRequest _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('LoginRequest');
  }

  @override
  final Function instantiate = _instantiate;

  static LoginRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginRequest>(map);
  }

  static LoginRequest fromJson(String json) {
    return ensureInitialized().decodeJson<LoginRequest>(json);
  }
}

mixin LoginRequestMappable {
  String toJson();
  Map<String, dynamic> toMap();
  LoginRequestCopyWith<LoginRequest, LoginRequest, LoginRequest> get copyWith;
}

abstract class LoginRequestCopyWith<$R, $In extends LoginRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? email, String? password});
  LoginRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class LoginResponseMapper extends ClassMapperBase<LoginResponse> {
  LoginResponseMapper._();

  static LoginResponseMapper? _instance;
  static LoginResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginResponseMapper._());
      UserModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LoginResponse';

  static UserModel _$user(LoginResponse v) => v.user;
  static const Field<LoginResponse, UserModel> _f$user = Field('user', _$user);
  static String _$token(LoginResponse v) => v.token;
  static const Field<LoginResponse, String> _f$token = Field('token', _$token);

  @override
  final MappableFields<LoginResponse> fields = const {
    #user: _f$user,
    #token: _f$token,
  };

  static LoginResponse _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('LoginResponse');
  }

  @override
  final Function instantiate = _instantiate;

  static LoginResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginResponse>(map);
  }

  static LoginResponse fromJson(String json) {
    return ensureInitialized().decodeJson<LoginResponse>(json);
  }
}

mixin LoginResponseMappable {
  String toJson();
  Map<String, dynamic> toMap();
  LoginResponseCopyWith<LoginResponse, LoginResponse, LoginResponse>
      get copyWith;
}

abstract class LoginResponseCopyWith<$R, $In extends LoginResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UserModelCopyWith<$R, UserModel, UserModel> get user;
  $R call({UserModel? user, String? token});
  LoginResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class RegisterRequestMapper extends ClassMapperBase<RegisterRequest> {
  RegisterRequestMapper._();

  static RegisterRequestMapper? _instance;
  static RegisterRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RegisterRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RegisterRequest';

  static String _$email(RegisterRequest v) => v.email;
  static const Field<RegisterRequest, String> _f$email =
      Field('email', _$email);
  static String _$password(RegisterRequest v) => v.password;
  static const Field<RegisterRequest, String> _f$password =
      Field('password', _$password);
  static String _$name(RegisterRequest v) => v.name;
  static const Field<RegisterRequest, String> _f$name = Field('name', _$name);
  static String _$deviceId(RegisterRequest v) => v.deviceId;
  static const Field<RegisterRequest, String> _f$deviceId =
      Field('deviceId', _$deviceId);

  @override
  final MappableFields<RegisterRequest> fields = const {
    #email: _f$email,
    #password: _f$password,
    #name: _f$name,
    #deviceId: _f$deviceId,
  };

  static RegisterRequest _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('RegisterRequest');
  }

  @override
  final Function instantiate = _instantiate;

  static RegisterRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RegisterRequest>(map);
  }

  static RegisterRequest fromJson(String json) {
    return ensureInitialized().decodeJson<RegisterRequest>(json);
  }
}

mixin RegisterRequestMappable {
  String toJson();
  Map<String, dynamic> toMap();
  RegisterRequestCopyWith<RegisterRequest, RegisterRequest, RegisterRequest>
      get copyWith;
}

abstract class RegisterRequestCopyWith<$R, $In extends RegisterRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? email, String? password, String? name, String? deviceId});
  RegisterRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class RegisterResponseMapper extends ClassMapperBase<RegisterResponse> {
  RegisterResponseMapper._();

  static RegisterResponseMapper? _instance;
  static RegisterResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RegisterResponseMapper._());
      UserModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RegisterResponse';

  static UserModel _$user(RegisterResponse v) => v.user;
  static const Field<RegisterResponse, UserModel> _f$user =
      Field('user', _$user);
  static String _$token(RegisterResponse v) => v.token;
  static const Field<RegisterResponse, String> _f$token =
      Field('token', _$token);

  @override
  final MappableFields<RegisterResponse> fields = const {
    #user: _f$user,
    #token: _f$token,
  };

  static RegisterResponse _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('RegisterResponse');
  }

  @override
  final Function instantiate = _instantiate;

  static RegisterResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RegisterResponse>(map);
  }

  static RegisterResponse fromJson(String json) {
    return ensureInitialized().decodeJson<RegisterResponse>(json);
  }
}

mixin RegisterResponseMappable {
  String toJson();
  Map<String, dynamic> toMap();
  RegisterResponseCopyWith<RegisterResponse, RegisterResponse, RegisterResponse>
      get copyWith;
}

abstract class RegisterResponseCopyWith<$R, $In extends RegisterResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UserModelCopyWith<$R, UserModel, UserModel> get user;
  $R call({UserModel? user, String? token});
  RegisterResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}
