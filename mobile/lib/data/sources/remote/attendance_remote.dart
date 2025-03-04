import 'dart:convert';

import 'package:on_time/data/models/attendance_model.dart';
import 'package:on_time/data/sources/local/dao/attendance_dao.dart';
import 'package:on_time/data/sources/remote/base_remote.dart';
import 'package:on_time/utils/logger.dart';

final class AttendanceRemote extends BaseRemote {
  final AttendanceDao attendanceDao;
  AttendanceRemote(super.userLocal, this.attendanceDao);

  Future<AttendanceModel?> saveAttendance(MarkAttendanceRequest args) async {
    final response = await post(
      '/attendances',
      args.toJson(),
      decoder: (obj) {
        if (obj['errors'] != null) {
          return obj;
        }
        return AttendanceModel.fromMap(obj['data']);
      },
    );

    final processed = handleStatusCode(response);

    if (processed is AttendanceModel) {
      await attendanceDao.saveAttendance(processed);
      return processed;
    } else if (processed is Exception) {
      throw processed;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<List<AttendanceModel>> getAttendances() async {
    final response = await get(
      '/attendances',
      decoder: (obj) {
        if (obj['errors'] != null) {
          return obj;
        }
        return List<AttendanceModel>.from(
          obj['data'].map((e) {
            log.f("MAP DATA $e");
            return AttendanceModel.fromMap(e);
          }),
        );
      },
    );

    final processed = handleStatusCode(response);

    if (processed is List<AttendanceModel>) {
      await attendanceDao.saveAttendances(processed);
      return processed;
    } else if (processed is String) {
      log.i('Processedx: $processed');

      final json = jsonDecode(processed);
      log.i('json: ${json['data']}');
      final mapped = List<AttendanceModel>.from(
        json['data'].map((e) {
          log.f("MAP DATA $e");
          return AttendanceModel.fromMap(e);
        }),
      );

      await attendanceDao.saveAttendances(mapped);
      return mapped;
    } else if (processed is Exception) {
      throw processed;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<AttendanceModel> getMyLatestAttendance(AttendanceType type) async {
    final response = await get('/attendances/me/latest', decoder: (obj) {
      if (obj['errors'] != null) {
        return obj;
      }

      return obj['data'] != null ? AttendanceModel.fromMap(obj['data']) : null;
    }, query: {
      'type': type.toString().split('.').last,
    });

    final processed = handleStatusCode(response);

    if (processed is AttendanceModel) {
      return processed;
    } else if (processed is Exception) {
      throw processed;
    } else {
      throw Exception('Something went wrong');
    }
  }
}
