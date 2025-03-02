// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'attendance_model.dart';

class AttendanceTypeMapper extends EnumMapper<AttendanceType> {
  AttendanceTypeMapper._();

  static AttendanceTypeMapper? _instance;
  static AttendanceTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AttendanceTypeMapper._());
    }
    return _instance!;
  }

  static AttendanceType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AttendanceType decode(dynamic value) {
    switch (value) {
      case 'GENESIS':
        return AttendanceType.GENESIS;
      case 'CLOCK_IN':
        return AttendanceType.CLOCK_IN;
      case 'CLOCK_OUT':
        return AttendanceType.CLOCK_OUT;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AttendanceType self) {
    switch (self) {
      case AttendanceType.GENESIS:
        return 'GENESIS';
      case AttendanceType.CLOCK_IN:
        return 'CLOCK_IN';
      case AttendanceType.CLOCK_OUT:
        return 'CLOCK_OUT';
    }
  }
}

extension AttendanceTypeMapperExtension on AttendanceType {
  String toValue() {
    AttendanceTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AttendanceType>(this) as String;
  }
}

class AttendanceModelMapper extends ClassMapperBase<AttendanceModel> {
  AttendanceModelMapper._();

  static AttendanceModelMapper? _instance;
  static AttendanceModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AttendanceModelMapper._());
      AttendanceTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AttendanceModel';

  static int _$id(AttendanceModel v) => v.id;
  static const Field<AttendanceModel, int> _f$id = Field('id', _$id);
  static int _$userId(AttendanceModel v) => v.userId;
  static const Field<AttendanceModel, int> _f$userId =
      Field('userId', _$userId);
  static double _$latitude(AttendanceModel v) => v.latitude;
  static const Field<AttendanceModel, double> _f$latitude =
      Field('latitude', _$latitude);
  static double _$longitude(AttendanceModel v) => v.longitude;
  static const Field<AttendanceModel, double> _f$longitude =
      Field('longitude', _$longitude);
  static AttendanceType _$type(AttendanceModel v) => v.type;
  static const Field<AttendanceModel, AttendanceType> _f$type =
      Field('type', _$type);
  static String _$date(AttendanceModel v) => v.date;
  static const Field<AttendanceModel, String> _f$date = Field('date', _$date);
  static BigInt _$timestamp(AttendanceModel v) => v.timestamp;
  static const Field<AttendanceModel, BigInt> _f$timestamp =
      Field('timestamp', _$timestamp);
  static String _$hash(AttendanceModel v) => v.hash;
  static const Field<AttendanceModel, String> _f$hash = Field('hash', _$hash);
  static String _$previousHash(AttendanceModel v) => v.previousHash;
  static const Field<AttendanceModel, String> _f$previousHash =
      Field('previousHash', _$previousHash);
  static int _$nonce(AttendanceModel v) => v.nonce;
  static const Field<AttendanceModel, int> _f$nonce = Field('nonce', _$nonce);

  @override
  final MappableFields<AttendanceModel> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #latitude: _f$latitude,
    #longitude: _f$longitude,
    #type: _f$type,
    #date: _f$date,
    #timestamp: _f$timestamp,
    #hash: _f$hash,
    #previousHash: _f$previousHash,
    #nonce: _f$nonce,
  };

  static AttendanceModel _instantiate(DecodingData data) {
    return AttendanceModel(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        latitude: data.dec(_f$latitude),
        longitude: data.dec(_f$longitude),
        type: data.dec(_f$type),
        date: data.dec(_f$date),
        timestamp: data.dec(_f$timestamp),
        hash: data.dec(_f$hash),
        previousHash: data.dec(_f$previousHash),
        nonce: data.dec(_f$nonce));
  }

  @override
  final Function instantiate = _instantiate;

  static AttendanceModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AttendanceModel>(map);
  }

  static AttendanceModel fromJson(String json) {
    return ensureInitialized().decodeJson<AttendanceModel>(json);
  }
}

mixin AttendanceModelMappable {
  String toJson() {
    return AttendanceModelMapper.ensureInitialized()
        .encodeJson<AttendanceModel>(this as AttendanceModel);
  }

  Map<String, dynamic> toMap() {
    return AttendanceModelMapper.ensureInitialized()
        .encodeMap<AttendanceModel>(this as AttendanceModel);
  }

  AttendanceModelCopyWith<AttendanceModel, AttendanceModel, AttendanceModel>
      get copyWith => _AttendanceModelCopyWithImpl(
          this as AttendanceModel, $identity, $identity);
  @override
  String toString() {
    return AttendanceModelMapper.ensureInitialized()
        .stringifyValue(this as AttendanceModel);
  }

  @override
  bool operator ==(Object other) {
    return AttendanceModelMapper.ensureInitialized()
        .equalsValue(this as AttendanceModel, other);
  }

  @override
  int get hashCode {
    return AttendanceModelMapper.ensureInitialized()
        .hashValue(this as AttendanceModel);
  }
}

extension AttendanceModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AttendanceModel, $Out> {
  AttendanceModelCopyWith<$R, AttendanceModel, $Out> get $asAttendanceModel =>
      $base.as((v, t, t2) => _AttendanceModelCopyWithImpl(v, t, t2));
}

abstract class AttendanceModelCopyWith<$R, $In extends AttendanceModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? id,
      int? userId,
      double? latitude,
      double? longitude,
      AttendanceType? type,
      String? date,
      BigInt? timestamp,
      String? hash,
      String? previousHash,
      int? nonce});
  AttendanceModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AttendanceModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AttendanceModel, $Out>
    implements AttendanceModelCopyWith<$R, AttendanceModel, $Out> {
  _AttendanceModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AttendanceModel> $mapper =
      AttendanceModelMapper.ensureInitialized();
  @override
  $R call(
          {int? id,
          int? userId,
          double? latitude,
          double? longitude,
          AttendanceType? type,
          String? date,
          BigInt? timestamp,
          String? hash,
          String? previousHash,
          int? nonce}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userId != null) #userId: userId,
        if (latitude != null) #latitude: latitude,
        if (longitude != null) #longitude: longitude,
        if (type != null) #type: type,
        if (date != null) #date: date,
        if (timestamp != null) #timestamp: timestamp,
        if (hash != null) #hash: hash,
        if (previousHash != null) #previousHash: previousHash,
        if (nonce != null) #nonce: nonce
      }));
  @override
  AttendanceModel $make(CopyWithData data) => AttendanceModel(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      latitude: data.get(#latitude, or: $value.latitude),
      longitude: data.get(#longitude, or: $value.longitude),
      type: data.get(#type, or: $value.type),
      date: data.get(#date, or: $value.date),
      timestamp: data.get(#timestamp, or: $value.timestamp),
      hash: data.get(#hash, or: $value.hash),
      previousHash: data.get(#previousHash, or: $value.previousHash),
      nonce: data.get(#nonce, or: $value.nonce));

  @override
  AttendanceModelCopyWith<$R2, AttendanceModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AttendanceModelCopyWithImpl($value, $cast, t);
}
