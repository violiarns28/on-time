import 'package:dart_mappable/dart_mappable.dart';
import 'package:on_time/data/sources/local/db/app_database.dart';

part 'attendance_model.mapper.dart';

@MappableEnum()
enum AttendanceType { GENESIS, CLOCK_IN, CLOCK_OUT }

@MappableClass()
class AttendanceModel with AttendanceModelMappable {
  final int id;
  final int userId;
  final double latitude;
  final double longitude;
  final AttendanceType type;
  final String date;
  final int timestamp;
  final String hash;
  final String previousHash;
  final int nonce;

  const AttendanceModel({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.date,
    required this.timestamp,
    required this.hash,
    required this.previousHash,
    required this.nonce,
  });

  static const fromMap = AttendanceModelMapper.fromMap;
  static const fromJson = AttendanceModelMapper.fromJson;

  factory AttendanceModel.fromLocal(AttendanceTableData data) =>
      AttendanceModel(
        id: data.id,
        userId: data.userId,
        latitude: data.latitude,
        longitude: data.longitude,
        type: data.type,
        date: data.date,
        timestamp: data.timestamp.toInt(),
        hash: data.hash,
        previousHash: data.previousHash,
        nonce: data.nonce,
      );

  AttendanceTableData toLocal() => AttendanceTableData(
        id: id,
        userId: userId,
        latitude: latitude,
        longitude: longitude,
        type: type,
        date: date,
        timestamp: BigInt.from(timestamp),
        hash: hash,
        previousHash: previousHash,
        nonce: nonce,
      );

  Future<void> upsert() => AppDatabase().attendanceDao.saveAttendance(this);
  Future<void> delete() => AppDatabase().attendanceDao.deleteAttendance(this);
}

@MappableClass()
class MarkAttendanceRequest with MarkAttendanceRequestMappable {
  final double latitude;
  final double longitude;
  final AttendanceType type;
  final String deviceId;

  const MarkAttendanceRequest({
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.deviceId,
  });

  static const fromMap = MarkAttendanceRequestMapper.fromMap;
  static const fromJson = MarkAttendanceRequestMapper.fromJson;
}
