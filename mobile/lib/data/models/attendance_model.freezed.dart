// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceModel {
  int get id;
  int get userId;
  double get latitude;
  double get longitude;
  AttendanceType get type;
  String get date;
  int get timestamp;
  String get hash;
  String get previousHash;
  int get nonce;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AttendanceModelCopyWith<AttendanceModel> get copyWith =>
      _$AttendanceModelCopyWithImpl<AttendanceModel>(
          this as AttendanceModel, _$identity);

  /// Serializes this AttendanceModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AttendanceModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.hash, hash) || other.hash == hash) &&
            (identical(other.previousHash, previousHash) ||
                other.previousHash == previousHash) &&
            (identical(other.nonce, nonce) || other.nonce == nonce));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, latitude, longitude,
      type, date, timestamp, hash, previousHash, nonce);

  @override
  String toString() {
    return 'AttendanceModel(id: $id, userId: $userId, latitude: $latitude, longitude: $longitude, type: $type, date: $date, timestamp: $timestamp, hash: $hash, previousHash: $previousHash, nonce: $nonce)';
  }
}

/// @nodoc
abstract mixin class $AttendanceModelCopyWith<$Res> {
  factory $AttendanceModelCopyWith(
          AttendanceModel value, $Res Function(AttendanceModel) _then) =
      _$AttendanceModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int userId,
      double latitude,
      double longitude,
      AttendanceType type,
      String date,
      int timestamp,
      String hash,
      String previousHash,
      int nonce});
}

/// @nodoc
class _$AttendanceModelCopyWithImpl<$Res>
    implements $AttendanceModelCopyWith<$Res> {
  _$AttendanceModelCopyWithImpl(this._self, this._then);

  final AttendanceModel _self;
  final $Res Function(AttendanceModel) _then;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? type = null,
    Object? date = null,
    Object? timestamp = null,
    Object? hash = null,
    Object? previousHash = null,
    Object? nonce = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      latitude: null == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AttendanceType,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      hash: null == hash
          ? _self.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
      previousHash: null == previousHash
          ? _self.previousHash
          : previousHash // ignore: cast_nullable_to_non_nullable
              as String,
      nonce: null == nonce
          ? _self.nonce
          : nonce // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AttendanceModel implements AttendanceModel {
  const _AttendanceModel(
      {required this.id,
      required this.userId,
      required this.latitude,
      required this.longitude,
      required this.type,
      required this.date,
      required this.timestamp,
      required this.hash,
      required this.previousHash,
      required this.nonce});
  factory _AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  @override
  final int id;
  @override
  final int userId;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final AttendanceType type;
  @override
  final String date;
  @override
  final int timestamp;
  @override
  final String hash;
  @override
  final String previousHash;
  @override
  final int nonce;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AttendanceModelCopyWith<_AttendanceModel> get copyWith =>
      __$AttendanceModelCopyWithImpl<_AttendanceModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AttendanceModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AttendanceModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.hash, hash) || other.hash == hash) &&
            (identical(other.previousHash, previousHash) ||
                other.previousHash == previousHash) &&
            (identical(other.nonce, nonce) || other.nonce == nonce));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, latitude, longitude,
      type, date, timestamp, hash, previousHash, nonce);

  @override
  String toString() {
    return 'AttendanceModel(id: $id, userId: $userId, latitude: $latitude, longitude: $longitude, type: $type, date: $date, timestamp: $timestamp, hash: $hash, previousHash: $previousHash, nonce: $nonce)';
  }
}

/// @nodoc
abstract mixin class _$AttendanceModelCopyWith<$Res>
    implements $AttendanceModelCopyWith<$Res> {
  factory _$AttendanceModelCopyWith(
          _AttendanceModel value, $Res Function(_AttendanceModel) _then) =
      __$AttendanceModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int userId,
      double latitude,
      double longitude,
      AttendanceType type,
      String date,
      int timestamp,
      String hash,
      String previousHash,
      int nonce});
}

/// @nodoc
class __$AttendanceModelCopyWithImpl<$Res>
    implements _$AttendanceModelCopyWith<$Res> {
  __$AttendanceModelCopyWithImpl(this._self, this._then);

  final _AttendanceModel _self;
  final $Res Function(_AttendanceModel) _then;

  /// Create a copy of AttendanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? type = null,
    Object? date = null,
    Object? timestamp = null,
    Object? hash = null,
    Object? previousHash = null,
    Object? nonce = null,
  }) {
    return _then(_AttendanceModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      latitude: null == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AttendanceType,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      hash: null == hash
          ? _self.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
      previousHash: null == previousHash
          ? _self.previousHash
          : previousHash // ignore: cast_nullable_to_non_nullable
              as String,
      nonce: null == nonce
          ? _self.nonce
          : nonce // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
