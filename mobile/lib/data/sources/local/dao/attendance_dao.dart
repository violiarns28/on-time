import 'package:drift/drift.dart';
import 'package:on_time/data/models/attendance_model.dart';
import 'package:on_time/data/sources/local/base_sql_local.dart';
import 'package:on_time/data/sources/local/tables/attendance_table.dart';

part 'attendance_dao.g.dart';

@DriftAccessor(tables: [AttendanceTable])
class AttendanceDao extends DatabaseAccessor<BaseSqlLocal>
    with _$AttendanceDaoMixin {
  AttendanceDao(super.db);

  Future<void> saveAttendance(AttendanceModel attendance) {
    return into(attendanceTable).insert(attendance.toLocal());
  }

  Future<List<AttendanceModel>> getAttendances() async {
    final result = await select(attendanceTable).get();
    return result.map((e) => AttendanceModel.fromLocal(e)).toList();
  }

  Future<void> deleteAttendance(AttendanceModel attendance) {
    return delete(attendanceTable).delete(attendance.toLocal());
  }
}
