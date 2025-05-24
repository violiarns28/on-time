// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_model.dart';

class UserModelMapper extends ClassMapperBase<UserModel> {
  UserModelMapper._();

  static UserModelMapper? _instance;
  static UserModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserModel';

  static int _$id(UserModel v) => v.id;
  static const Field<UserModel, int> _f$id = Field('id', _$id);
  static String _$name(UserModel v) => v.name;
  static const Field<UserModel, String> _f$name = Field('name', _$name);
  static String _$email(UserModel v) => v.email;
  static const Field<UserModel, String> _f$email = Field('email', _$email);
  static String? _$createdAt(UserModel v) => v.createdAt;
  static const Field<UserModel, String> _f$createdAt =
      Field('createdAt', _$createdAt, opt: true);
  static String? _$updatedAt(UserModel v) => v.updatedAt;
  static const Field<UserModel, String> _f$updatedAt =
      Field('updatedAt', _$updatedAt, opt: true);

  @override
  final MappableFields<UserModel> fields = const {
    #id: _f$id,
    #name: _f$name,
    #email: _f$email,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static UserModel _instantiate(DecodingData data) {
    return UserModel(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        email: data.dec(_f$email),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static UserModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserModel>(map);
  }

  static UserModel fromJson(String json) {
    return ensureInitialized().decodeJson<UserModel>(json);
  }
}

mixin UserModelMappable {
  String toJson() {
    return UserModelMapper.ensureInitialized()
        .encodeJson<UserModel>(this as UserModel);
  }

  Map<String, dynamic> toMap() {
    return UserModelMapper.ensureInitialized()
        .encodeMap<UserModel>(this as UserModel);
  }

  UserModelCopyWith<UserModel, UserModel, UserModel> get copyWith =>
      _UserModelCopyWithImpl(this as UserModel, $identity, $identity);
  @override
  String toString() {
    return UserModelMapper.ensureInitialized()
        .stringifyValue(this as UserModel);
  }

  @override
  bool operator ==(Object other) {
    return UserModelMapper.ensureInitialized()
        .equalsValue(this as UserModel, other);
  }

  @override
  int get hashCode {
    return UserModelMapper.ensureInitialized().hashValue(this as UserModel);
  }
}

extension UserModelValueCopy<$R, $Out> on ObjectCopyWith<$R, UserModel, $Out> {
  UserModelCopyWith<$R, UserModel, $Out> get $asUserModel =>
      $base.as((v, t, t2) => _UserModelCopyWithImpl(v, t, t2));
}

abstract class UserModelCopyWith<$R, $In extends UserModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? id,
      String? name,
      String? email,
      String? createdAt,
      String? updatedAt});
  UserModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserModel, $Out>
    implements UserModelCopyWith<$R, UserModel, $Out> {
  _UserModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserModel> $mapper =
      UserModelMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          String? name,
          String? email,
          Object? createdAt = $none,
          Object? updatedAt = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (name != null) #name: name,
        if (email != null) #email: email,
        if (createdAt != $none) #createdAt: createdAt,
        if (updatedAt != $none) #updatedAt: updatedAt
      }));
  @override
  UserModel $make(CopyWithData data) => UserModel(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      email: data.get(#email, or: $value.email),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt));

  @override
  UserModelCopyWith<$R2, UserModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserModelCopyWithImpl($value, $cast, t);
}

class UpdateProfileRequestMapper extends ClassMapperBase<UpdateProfileRequest> {
  UpdateProfileRequestMapper._();

  static UpdateProfileRequestMapper? _instance;
  static UpdateProfileRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UpdateProfileRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UpdateProfileRequest';

  static int? _$id(UpdateProfileRequest v) => v.id;
  static const Field<UpdateProfileRequest, int> _f$id =
      Field('id', _$id, opt: true);
  static String? _$name(UpdateProfileRequest v) => v.name;
  static const Field<UpdateProfileRequest, String> _f$name =
      Field('name', _$name, opt: true);
  static String? _$email(UpdateProfileRequest v) => v.email;
  static const Field<UpdateProfileRequest, String> _f$email =
      Field('email', _$email, opt: true);
  static String? _$password(UpdateProfileRequest v) => v.password;
  static const Field<UpdateProfileRequest, String> _f$password =
      Field('password', _$password, opt: true);

  @override
  final MappableFields<UpdateProfileRequest> fields = const {
    #id: _f$id,
    #name: _f$name,
    #email: _f$email,
    #password: _f$password,
  };

  static UpdateProfileRequest _instantiate(DecodingData data) {
    return UpdateProfileRequest(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        email: data.dec(_f$email),
        password: data.dec(_f$password));
  }

  @override
  final Function instantiate = _instantiate;

  static UpdateProfileRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UpdateProfileRequest>(map);
  }

  static UpdateProfileRequest fromJson(String json) {
    return ensureInitialized().decodeJson<UpdateProfileRequest>(json);
  }
}

mixin UpdateProfileRequestMappable {
  String toJson() {
    return UpdateProfileRequestMapper.ensureInitialized()
        .encodeJson<UpdateProfileRequest>(this as UpdateProfileRequest);
  }

  Map<String, dynamic> toMap() {
    return UpdateProfileRequestMapper.ensureInitialized()
        .encodeMap<UpdateProfileRequest>(this as UpdateProfileRequest);
  }

  UpdateProfileRequestCopyWith<UpdateProfileRequest, UpdateProfileRequest,
          UpdateProfileRequest>
      get copyWith => _UpdateProfileRequestCopyWithImpl(
          this as UpdateProfileRequest, $identity, $identity);
  @override
  String toString() {
    return UpdateProfileRequestMapper.ensureInitialized()
        .stringifyValue(this as UpdateProfileRequest);
  }

  @override
  bool operator ==(Object other) {
    return UpdateProfileRequestMapper.ensureInitialized()
        .equalsValue(this as UpdateProfileRequest, other);
  }

  @override
  int get hashCode {
    return UpdateProfileRequestMapper.ensureInitialized()
        .hashValue(this as UpdateProfileRequest);
  }
}

extension UpdateProfileRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UpdateProfileRequest, $Out> {
  UpdateProfileRequestCopyWith<$R, UpdateProfileRequest, $Out>
      get $asUpdateProfileRequest =>
          $base.as((v, t, t2) => _UpdateProfileRequestCopyWithImpl(v, t, t2));
}

abstract class UpdateProfileRequestCopyWith<
    $R,
    $In extends UpdateProfileRequest,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, String? name, String? email, String? password});
  UpdateProfileRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _UpdateProfileRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UpdateProfileRequest, $Out>
    implements UpdateProfileRequestCopyWith<$R, UpdateProfileRequest, $Out> {
  _UpdateProfileRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UpdateProfileRequest> $mapper =
      UpdateProfileRequestMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          Object? name = $none,
          Object? email = $none,
          Object? password = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (name != $none) #name: name,
        if (email != $none) #email: email,
        if (password != $none) #password: password
      }));
  @override
  UpdateProfileRequest $make(CopyWithData data) => UpdateProfileRequest(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      email: data.get(#email, or: $value.email),
      password: data.get(#password, or: $value.password));

  @override
  UpdateProfileRequestCopyWith<$R2, UpdateProfileRequest, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _UpdateProfileRequestCopyWithImpl($value, $cast, t);
}
