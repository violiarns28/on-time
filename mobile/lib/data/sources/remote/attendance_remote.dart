import 'package:on_time/core/constants.dart';
import 'package:on_time/data/models/attendance_model.dart';
import 'package:on_time/data/sources/local/dao/attendance_dao.dart';
import 'package:on_time/data/sources/remote/base_remote.dart';

final class AttendanceRemote extends BaseRemote {
  final AttendanceDao attendanceLocal;
  AttendanceRemote(super.userLocal, this.attendanceLocal);

  @override
  Future<void> onInit() async {
    httpClient.baseUrl = '${Constants.baseUrl}/attendances';
    super.onInit();
  }

  Future<void> saveAttendance(AttendanceModel attendance) async {
    final response = await post(
      '/',
      attendance.toJson(),
      decoder: (obj) => AttendanceModel.fromJson(obj['data']),
    );

    final processed = handleStatusCode(response);

    if (processed is AttendanceModel) {
      await attendanceLocal.saveAttendance(processed);
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<List<AttendanceModel>> getAttendances() async {
    final response = await get(
      '/',
      decoder: (obj) => List<AttendanceModel>.from(
        obj['data'].map((e) => AttendanceModel.fromJson(e)),
      ),
    );

    final processed = handleStatusCode(response);

    if (processed is List<AttendanceModel>) {
      await attendanceLocal.saveAttendances(processed);
      return processed;
    } else {
      throw Exception('Something went wrong');
    }
  }
}
