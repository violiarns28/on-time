// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blockchain_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockchainDataModel {
  String get type;
  String get action;
  int get attendaceId;
  int get userId;
  String get date;
  String? get clockIn;
  String? get clockOut;
  int get timestamp;

  /// Create a copy of BlockchainDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockchainDataModelCopyWith<BlockchainDataModel> get copyWith =>
      _$BlockchainDataModelCopyWithImpl<BlockchainDataModel>(
          this as BlockchainDataModel, _$identity);

  /// Serializes this BlockchainDataModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockchainDataModel &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.attendaceId, attendaceId) ||
                other.attendaceId == attendaceId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.clockIn, clockIn) || other.clockIn == clockIn) &&
            (identical(other.clockOut, clockOut) ||
                other.clockOut == clockOut) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, action, attendaceId,
      userId, date, clockIn, clockOut, timestamp);

  @override
  String toString() {
    return 'BlockchainDataModel(type: $type, action: $action, attendaceId: $attendaceId, userId: $userId, date: $date, clockIn: $clockIn, clockOut: $clockOut, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class $BlockchainDataModelCopyWith<$Res> {
  factory $BlockchainDataModelCopyWith(
          BlockchainDataModel value, $Res Function(BlockchainDataModel) _then) =
      _$BlockchainDataModelCopyWithImpl;
  @useResult
  $Res call(
      {String type,
      String action,
      int attendaceId,
      int userId,
      String date,
      String? clockIn,
      String? clockOut,
      int timestamp});
}

/// @nodoc
class _$BlockchainDataModelCopyWithImpl<$Res>
    implements $BlockchainDataModelCopyWith<$Res> {
  _$BlockchainDataModelCopyWithImpl(this._self, this._then);

  final BlockchainDataModel _self;
  final $Res Function(BlockchainDataModel) _then;

  /// Create a copy of BlockchainDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? action = null,
    Object? attendaceId = null,
    Object? userId = null,
    Object? date = null,
    Object? clockIn = freezed,
    Object? clockOut = freezed,
    Object? timestamp = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      attendaceId: null == attendaceId
          ? _self.attendaceId
          : attendaceId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      clockIn: freezed == clockIn
          ? _self.clockIn
          : clockIn // ignore: cast_nullable_to_non_nullable
              as String?,
      clockOut: freezed == clockOut
          ? _self.clockOut
          : clockOut // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _BlockchainDataModel implements BlockchainDataModel {
  const _BlockchainDataModel(
      {required this.type,
      required this.action,
      required this.attendaceId,
      required this.userId,
      required this.date,
      this.clockIn,
      this.clockOut,
      required this.timestamp});
  factory _BlockchainDataModel.fromJson(Map<String, dynamic> json) =>
      _$BlockchainDataModelFromJson(json);

  @override
  final String type;
  @override
  final String action;
  @override
  final int attendaceId;
  @override
  final int userId;
  @override
  final String date;
  @override
  final String? clockIn;
  @override
  final String? clockOut;
  @override
  final int timestamp;

  /// Create a copy of BlockchainDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BlockchainDataModelCopyWith<_BlockchainDataModel> get copyWith =>
      __$BlockchainDataModelCopyWithImpl<_BlockchainDataModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BlockchainDataModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BlockchainDataModel &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.attendaceId, attendaceId) ||
                other.attendaceId == attendaceId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.clockIn, clockIn) || other.clockIn == clockIn) &&
            (identical(other.clockOut, clockOut) ||
                other.clockOut == clockOut) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, action, attendaceId,
      userId, date, clockIn, clockOut, timestamp);

  @override
  String toString() {
    return 'BlockchainDataModel(type: $type, action: $action, attendaceId: $attendaceId, userId: $userId, date: $date, clockIn: $clockIn, clockOut: $clockOut, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class _$BlockchainDataModelCopyWith<$Res>
    implements $BlockchainDataModelCopyWith<$Res> {
  factory _$BlockchainDataModelCopyWith(_BlockchainDataModel value,
          $Res Function(_BlockchainDataModel) _then) =
      __$BlockchainDataModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String type,
      String action,
      int attendaceId,
      int userId,
      String date,
      String? clockIn,
      String? clockOut,
      int timestamp});
}

/// @nodoc
class __$BlockchainDataModelCopyWithImpl<$Res>
    implements _$BlockchainDataModelCopyWith<$Res> {
  __$BlockchainDataModelCopyWithImpl(this._self, this._then);

  final _BlockchainDataModel _self;
  final $Res Function(_BlockchainDataModel) _then;

  /// Create a copy of BlockchainDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? action = null,
    Object? attendaceId = null,
    Object? userId = null,
    Object? date = null,
    Object? clockIn = freezed,
    Object? clockOut = freezed,
    Object? timestamp = null,
  }) {
    return _then(_BlockchainDataModel(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      attendaceId: null == attendaceId
          ? _self.attendaceId
          : attendaceId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      clockIn: freezed == clockIn
          ? _self.clockIn
          : clockIn // ignore: cast_nullable_to_non_nullable
              as String?,
      clockOut: freezed == clockOut
          ? _self.clockOut
          : clockOut // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$BlockchainModel {
  int get id;
  int get blocIndex;
  int get timestamp;
  BlockchainDataModel get data;
  String get previousHash;
  String get hash;
  int get nonce;

  /// Create a copy of BlockchainModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockchainModelCopyWith<BlockchainModel> get copyWith =>
      _$BlockchainModelCopyWithImpl<BlockchainModel>(
          this as BlockchainModel, _$identity);

  /// Serializes this BlockchainModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockchainModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.blocIndex, blocIndex) ||
                other.blocIndex == blocIndex) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.previousHash, previousHash) ||
                other.previousHash == previousHash) &&
            (identical(other.hash, hash) || other.hash == hash) &&
            (identical(other.nonce, nonce) || other.nonce == nonce));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, blocIndex, timestamp, data, previousHash, hash, nonce);

  @override
  String toString() {
    return 'BlockchainModel(id: $id, blocIndex: $blocIndex, timestamp: $timestamp, data: $data, previousHash: $previousHash, hash: $hash, nonce: $nonce)';
  }
}

/// @nodoc
abstract mixin class $BlockchainModelCopyWith<$Res> {
  factory $BlockchainModelCopyWith(
          BlockchainModel value, $Res Function(BlockchainModel) _then) =
      _$BlockchainModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int blocIndex,
      int timestamp,
      BlockchainDataModel data,
      String previousHash,
      String hash,
      int nonce});

  $BlockchainDataModelCopyWith<$Res> get data;
}

/// @nodoc
class _$BlockchainModelCopyWithImpl<$Res>
    implements $BlockchainModelCopyWith<$Res> {
  _$BlockchainModelCopyWithImpl(this._self, this._then);

  final BlockchainModel _self;
  final $Res Function(BlockchainModel) _then;

  /// Create a copy of BlockchainModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? blocIndex = null,
    Object? timestamp = null,
    Object? data = null,
    Object? previousHash = null,
    Object? hash = null,
    Object? nonce = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      blocIndex: null == blocIndex
          ? _self.blocIndex
          : blocIndex // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as BlockchainDataModel,
      previousHash: null == previousHash
          ? _self.previousHash
          : previousHash // ignore: cast_nullable_to_non_nullable
              as String,
      hash: null == hash
          ? _self.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
      nonce: null == nonce
          ? _self.nonce
          : nonce // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of BlockchainModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BlockchainDataModelCopyWith<$Res> get data {
    return $BlockchainDataModelCopyWith<$Res>(_self.data, (value) {
      return _then(_self.copyWith(data: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _BlockchainModel implements BlockchainModel {
  const _BlockchainModel(
      {required this.id,
      required this.blocIndex,
      required this.timestamp,
      required this.data,
      required this.previousHash,
      required this.hash,
      required this.nonce});
  factory _BlockchainModel.fromJson(Map<String, dynamic> json) =>
      _$BlockchainModelFromJson(json);

  @override
  final int id;
  @override
  final int blocIndex;
  @override
  final int timestamp;
  @override
  final BlockchainDataModel data;
  @override
  final String previousHash;
  @override
  final String hash;
  @override
  final int nonce;

  /// Create a copy of BlockchainModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BlockchainModelCopyWith<_BlockchainModel> get copyWith =>
      __$BlockchainModelCopyWithImpl<_BlockchainModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BlockchainModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BlockchainModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.blocIndex, blocIndex) ||
                other.blocIndex == blocIndex) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.previousHash, previousHash) ||
                other.previousHash == previousHash) &&
            (identical(other.hash, hash) || other.hash == hash) &&
            (identical(other.nonce, nonce) || other.nonce == nonce));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, blocIndex, timestamp, data, previousHash, hash, nonce);

  @override
  String toString() {
    return 'BlockchainModel(id: $id, blocIndex: $blocIndex, timestamp: $timestamp, data: $data, previousHash: $previousHash, hash: $hash, nonce: $nonce)';
  }
}

/// @nodoc
abstract mixin class _$BlockchainModelCopyWith<$Res>
    implements $BlockchainModelCopyWith<$Res> {
  factory _$BlockchainModelCopyWith(
          _BlockchainModel value, $Res Function(_BlockchainModel) _then) =
      __$BlockchainModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int blocIndex,
      int timestamp,
      BlockchainDataModel data,
      String previousHash,
      String hash,
      int nonce});

  @override
  $BlockchainDataModelCopyWith<$Res> get data;
}

/// @nodoc
class __$BlockchainModelCopyWithImpl<$Res>
    implements _$BlockchainModelCopyWith<$Res> {
  __$BlockchainModelCopyWithImpl(this._self, this._then);

  final _BlockchainModel _self;
  final $Res Function(_BlockchainModel) _then;

  /// Create a copy of BlockchainModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? blocIndex = null,
    Object? timestamp = null,
    Object? data = null,
    Object? previousHash = null,
    Object? hash = null,
    Object? nonce = null,
  }) {
    return _then(_BlockchainModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      blocIndex: null == blocIndex
          ? _self.blocIndex
          : blocIndex // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as BlockchainDataModel,
      previousHash: null == previousHash
          ? _self.previousHash
          : previousHash // ignore: cast_nullable_to_non_nullable
              as String,
      hash: null == hash
          ? _self.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
      nonce: null == nonce
          ? _self.nonce
          : nonce // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of BlockchainModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BlockchainDataModelCopyWith<$Res> get data {
    return $BlockchainDataModelCopyWith<$Res>(_self.data, (value) {
      return _then(_self.copyWith(data: value));
    });
  }
}

// dart format on
