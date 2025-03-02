import 'package:on_time/core/constants.dart';
import 'package:on_time/data/models/attendance_model.dart';
import 'package:on_time/data/sources/local/dao/attendance_dao.dart';
import 'package:on_time/data/sources/remote/base_remote.dart';

final class AttendanceRemote extends BaseRemote {
  final AttendanceDao attendanceDao;
  AttendanceRemote(super.userLocal, this.attendanceDao);

  @override
  Future<void> onInit() async {
    httpClient.baseUrl = '${Constants.baseUrl}/attendances';
    super.onInit();
  }

  Future<AttendanceModel?> saveAttendance(MarkAttendanceRequest args) async {
    final response = await post(
      '/',
      args.toJson(),
      decoder: (obj) => AttendanceModel.fromJson(obj['data']),
    );

    final processed = handleStatusCode(response);

    if (processed is AttendanceModel) {
      await attendanceDao.saveAttendance(processed);
      return processed;
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
      await attendanceDao.saveAttendances(processed);
      return processed;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<AttendanceModel> getMyLatestAttendance(AttendanceType type) async {
    final response = await get('/me/latest',
        decoder: (obj) =>
            obj['data'] != null ? AttendanceModel.fromJson(obj['data']) : null,
        query: {
          'type': type.toString().split('.').last,
        });

    final processed = handleStatusCode(response);

    if (processed is AttendanceModel) {
      return processed;
    } else {
      throw Exception('Something went wrong');
    }
  }
}
