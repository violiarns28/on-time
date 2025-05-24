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
    return LoginRequest(
        email: data.dec(_f$email), password: data.dec(_f$password));
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
  String toJson() {
    return LoginRequestMapper.ensureInitialized()
        .encodeJson<LoginRequest>(this as LoginRequest);
  }

  Map<String, dynamic> toMap() {
    return LoginRequestMapper.ensureInitialized()
        .encodeMap<LoginRequest>(this as LoginRequest);
  }

  LoginRequestCopyWith<LoginRequest, LoginRequest, LoginRequest> get copyWith =>
      _LoginRequestCopyWithImpl(this as LoginRequest, $identity, $identity);
  @override
  String toString() {
    return LoginRequestMapper.ensureInitialized()
        .stringifyValue(this as LoginRequest);
  }

  @override
  bool operator ==(Object other) {
    return LoginRequestMapper.ensureInitialized()
        .equalsValue(this as LoginRequest, other);
  }

  @override
  int get hashCode {
    return LoginRequestMapper.ensureInitialized()
        .hashValue(this as LoginRequest);
  }
}

extension LoginRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginRequest, $Out> {
  LoginRequestCopyWith<$R, LoginRequest, $Out> get $asLoginRequest =>
      $base.as((v, t, t2) => _LoginRequestCopyWithImpl(v, t, t2));
}

abstract class LoginRequestCopyWith<$R, $In extends LoginRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? email, String? password});
  LoginRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LoginRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginRequest, $Out>
    implements LoginRequestCopyWith<$R, LoginRequest, $Out> {
  _LoginRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginRequest> $mapper =
      LoginRequestMapper.ensureInitialized();
  @override
  $R call({String? email, String? password}) => $apply(FieldCopyWithData({
        if (email != null) #email: email,
        if (password != null) #password: password
      }));
  @override
  LoginRequest $make(CopyWithData data) => LoginRequest(
      email: data.get(#email, or: $value.email),
      password: data.get(#password, or: $value.password));

  @override
  LoginRequestCopyWith<$R2, LoginRequest, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _LoginRequestCopyWithImpl($value, $cast, t);
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
    return LoginResponse(user: data.dec(_f$user), token: data.dec(_f$token));
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
  String toJson() {
    return LoginResponseMapper.ensureInitialized()
        .encodeJson<LoginResponse>(this as LoginResponse);
  }

  Map<String, dynamic> toMap() {
    return LoginResponseMapper.ensureInitialized()
        .encodeMap<LoginResponse>(this as LoginResponse);
  }

  LoginResponseCopyWith<LoginResponse, LoginResponse, LoginResponse>
      get copyWith => _LoginResponseCopyWithImpl(
          this as LoginResponse, $identity, $identity);
  @override
  String toString() {
    return LoginResponseMapper.ensureInitialized()
        .stringifyValue(this as LoginResponse);
  }

  @override
  bool operator ==(Object other) {
    return LoginResponseMapper.ensureInitialized()
        .equalsValue(this as LoginResponse, other);
  }

  @override
  int get hashCode {
    return LoginResponseMapper.ensureInitialized()
        .hashValue(this as LoginResponse);
  }
}

extension LoginResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginResponse, $Out> {
  LoginResponseCopyWith<$R, LoginResponse, $Out> get $asLoginResponse =>
      $base.as((v, t, t2) => _LoginResponseCopyWithImpl(v, t, t2));
}

abstract class LoginResponseCopyWith<$R, $In extends LoginResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UserModelCopyWith<$R, UserModel, UserModel> get user;
  $R call({UserModel? user, String? token});
  LoginResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LoginResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginResponse, $Out>
    implements LoginResponseCopyWith<$R, LoginResponse, $Out> {
  _LoginResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginResponse> $mapper =
      LoginResponseMapper.ensureInitialized();
  @override
  UserModelCopyWith<$R, UserModel, UserModel> get user =>
      $value.user.copyWith.$chain((v) => call(user: v));
  @override
  $R call({UserModel? user, String? token}) => $apply(FieldCopyWithData(
      {if (user != null) #user: user, if (token != null) #token: token}));
  @override
  LoginResponse $make(CopyWithData data) => LoginResponse(
      user: data.get(#user, or: $value.user),
      token: data.get(#token, or: $value.token));

  @override
  LoginResponseCopyWith<$R2, LoginResponse, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _LoginResponseCopyWithImpl($value, $cast, t);
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

  @override
  final MappableFields<RegisterRequest> fields = const {
    #email: _f$email,
    #password: _f$password,
    #name: _f$name,
  };

  static RegisterRequest _instantiate(DecodingData data) {
    return RegisterRequest(
        email: data.dec(_f$email),
        password: data.dec(_f$password),
        name: data.dec(_f$name));
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
  String toJson() {
    return RegisterRequestMapper.ensureInitialized()
        .encodeJson<RegisterRequest>(this as RegisterRequest);
  }

  Map<String, dynamic> toMap() {
    return RegisterRequestMapper.ensureInitialized()
        .encodeMap<RegisterRequest>(this as RegisterRequest);
  }

  RegisterRequestCopyWith<RegisterRequest, RegisterRequest, RegisterRequest>
      get copyWith => _RegisterRequestCopyWithImpl(
          this as RegisterRequest, $identity, $identity);
  @override
  String toString() {
    return RegisterRequestMapper.ensureInitialized()
        .stringifyValue(this as RegisterRequest);
  }

  @override
  bool operator ==(Object other) {
    return RegisterRequestMapper.ensureInitialized()
        .equalsValue(this as RegisterRequest, other);
  }

  @override
  int get hashCode {
    return RegisterRequestMapper.ensureInitialized()
        .hashValue(this as RegisterRequest);
  }
}

extension RegisterRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RegisterRequest, $Out> {
  RegisterRequestCopyWith<$R, RegisterRequest, $Out> get $asRegisterRequest =>
      $base.as((v, t, t2) => _RegisterRequestCopyWithImpl(v, t, t2));
}

abstract class RegisterRequestCopyWith<$R, $In extends RegisterRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? email, String? password, String? name});
  RegisterRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _RegisterRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RegisterRequest, $Out>
    implements RegisterRequestCopyWith<$R, RegisterRequest, $Out> {
  _RegisterRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RegisterRequest> $mapper =
      RegisterRequestMapper.ensureInitialized();
  @override
  $R call({String? email, String? password, String? name}) =>
      $apply(FieldCopyWithData({
        if (email != null) #email: email,
        if (password != null) #password: password,
        if (name != null) #name: name
      }));
  @override
  RegisterRequest $make(CopyWithData data) => RegisterRequest(
      email: data.get(#email, or: $value.email),
      password: data.get(#password, or: $value.password),
      name: data.get(#name, or: $value.name));

  @override
  RegisterRequestCopyWith<$R2, RegisterRequest, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RegisterRequestCopyWithImpl($value, $cast, t);
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
    return RegisterResponse(user: data.dec(_f$user), token: data.dec(_f$token));
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
  String toJson() {
    return RegisterResponseMapper.ensureInitialized()
        .encodeJson<RegisterResponse>(this as RegisterResponse);
  }

  Map<String, dynamic> toMap() {
    return RegisterResponseMapper.ensureInitialized()
        .encodeMap<RegisterResponse>(this as RegisterResponse);
  }

  RegisterResponseCopyWith<RegisterResponse, RegisterResponse, RegisterResponse>
      get copyWith => _RegisterResponseCopyWithImpl(
          this as RegisterResponse, $identity, $identity);
  @override
  String toString() {
    return RegisterResponseMapper.ensureInitialized()
        .stringifyValue(this as RegisterResponse);
  }

  @override
  bool operator ==(Object other) {
    return RegisterResponseMapper.ensureInitialized()
        .equalsValue(this as RegisterResponse, other);
  }

  @override
  int get hashCode {
    return RegisterResponseMapper.ensureInitialized()
        .hashValue(this as RegisterResponse);
  }
}

extension RegisterResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RegisterResponse, $Out> {
  RegisterResponseCopyWith<$R, RegisterResponse, $Out>
      get $asRegisterResponse =>
          $base.as((v, t, t2) => _RegisterResponseCopyWithImpl(v, t, t2));
}

abstract class RegisterResponseCopyWith<$R, $In extends RegisterResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UserModelCopyWith<$R, UserModel, UserModel> get user;
  $R call({UserModel? user, String? token});
  RegisterResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _RegisterResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RegisterResponse, $Out>
    implements RegisterResponseCopyWith<$R, RegisterResponse, $Out> {
  _RegisterResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RegisterResponse> $mapper =
      RegisterResponseMapper.ensureInitialized();
  @override
  UserModelCopyWith<$R, UserModel, UserModel> get user =>
      $value.user.copyWith.$chain((v) => call(user: v));
  @override
  $R call({UserModel? user, String? token}) => $apply(FieldCopyWithData(
      {if (user != null) #user: user, if (token != null) #token: token}));
  @override
  RegisterResponse $make(CopyWithData data) => RegisterResponse(
      user: data.get(#user, or: $value.user),
      token: data.get(#token, or: $value.token));

  @override
  RegisterResponseCopyWith<$R2, RegisterResponse, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RegisterResponseCopyWithImpl($value, $cast, t);
}
