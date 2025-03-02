import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

enum AttendanceType { GENESIS, CLOCK_IN, CLOCK_OUT }

@freezed
abstract class AttendanceModel with _$AttendanceModel {
  const factory AttendanceModel({
    required int id,
    required int userId,
    required double latitude,
    required double longitude,
    required AttendanceType type,
    required String date,
    required int timestamp,
    required String hash,
    required String previousHash,
    required int nonce,
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);
}
