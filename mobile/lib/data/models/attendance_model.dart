import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_time/data/sources/local/base_sql_local.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

enum AttendanceType { GENESIS, CLOCK_IN, CLOCK_OUT }

@freezed
abstract class AttendanceModel with _$AttendanceModel {
  const AttendanceModel._();
  const factory AttendanceModel({
    required int id,
    required int userId,
    required double latitude,
    required double longitude,
    required AttendanceType type,
    required String date,
    required BigInt timestamp,
    required String hash,
    required String previousHash,
    required int nonce,
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  factory AttendanceModel.fromLocal(AttendanceTableData data) =>
      AttendanceModel(
        id: data.id,
        userId: data.userId,
        latitude: data.latitude,
        longitude: data.longitude,
        type: data.type,
        date: data.date,
        timestamp: data.timestamp,
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
        timestamp: timestamp,
        hash: hash,
        previousHash: previousHash,
        nonce: nonce,
      );
}
