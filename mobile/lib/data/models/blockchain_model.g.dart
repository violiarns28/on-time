// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blockchain_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockchainDataModel _$BlockchainDataModelFromJson(Map<String, dynamic> json) =>
    _BlockchainDataModel(
      type: json['type'] as String,
      action: json['action'] as String,
      attendaceId: (json['attendaceId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      date: json['date'] as String,
      clockIn: json['clockIn'] as String?,
      clockOut: json['clockOut'] as String?,
      timestamp: (json['timestamp'] as num).toInt(),
    );

Map<String, dynamic> _$BlockchainDataModelToJson(
        _BlockchainDataModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'action': instance.action,
      'attendaceId': instance.attendaceId,
      'userId': instance.userId,
      'date': instance.date,
      'clockIn': instance.clockIn,
      'clockOut': instance.clockOut,
      'timestamp': instance.timestamp,
    };

_BlockchainModel _$BlockchainModelFromJson(Map<String, dynamic> json) =>
    _BlockchainModel(
      id: (json['id'] as num).toInt(),
      blocIndex: (json['blocIndex'] as num).toInt(),
      timestamp: (json['timestamp'] as num).toInt(),
      data: BlockchainDataModel.fromJson(json['data'] as Map<String, dynamic>),
      previousHash: json['previousHash'] as String,
      hash: json['hash'] as String,
      nonce: (json['nonce'] as num).toInt(),
    );

Map<String, dynamic> _$BlockchainModelToJson(_BlockchainModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'blocIndex': instance.blocIndex,
      'timestamp': instance.timestamp,
      'data': instance.data,
      'previousHash': instance.previousHash,
      'hash': instance.hash,
      'nonce': instance.nonce,
    };
