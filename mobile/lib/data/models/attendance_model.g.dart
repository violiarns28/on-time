// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    _AttendanceModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      type: $enumDecode(_$AttendanceTypeEnumMap, json['type']),
      date: json['date'] as String,
      timestamp: BigInt.parse(json['timestamp'] as String),
      hash: json['hash'] as String,
      previousHash: json['previousHash'] as String,
      nonce: (json['nonce'] as num).toInt(),
    );

Map<String, dynamic> _$AttendanceModelToJson(_AttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'type': _$AttendanceTypeEnumMap[instance.type]!,
      'date': instance.date,
      'timestamp': instance.timestamp.toString(),
      'hash': instance.hash,
      'previousHash': instance.previousHash,
      'nonce': instance.nonce,
    };

const _$AttendanceTypeEnumMap = {
  AttendanceType.GENESIS: 'GENESIS',
  AttendanceType.CLOCK_IN: 'CLOCK_IN',
  AttendanceType.CLOCK_OUT: 'CLOCK_OUT',
};
