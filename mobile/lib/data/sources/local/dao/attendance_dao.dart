import 'package:drift/drift.dart';
import 'package:on_time/data/models/attendance_model.dart';
import 'package:on_time/data/sources/local/db/app_database.dart';
import 'package:on_time/data/sources/local/db/attendance_table.dart';

part 'attendance_dao.g.dart';

@DriftAccessor(tables: [AttendanceTable])
class AttendanceDao extends DatabaseAccessor<AppDatabase>
    with _$AttendanceDaoMixin {
  AttendanceDao(super.db);

  Future<void> saveAttendance(AttendanceModel attendance) {
    return into(attendanceTable).insert(
      attendance.toLocal(),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<List<AttendanceModel>> getAttendances() async {
    final result = await select(attendanceTable).get();
    return result.map((e) => AttendanceModel.fromLocal(e)).toList();
  }

  Stream<List<AttendanceModel>> watchAttendances() {
    return select(attendanceTable).watch().map((event) {
      return event.map((e) => AttendanceModel.fromLocal(e)).toList();
    });
  }

  Future<void> deleteAttendance(AttendanceModel attendance) {
    return delete(attendanceTable).delete(attendance.toLocal());
  }
}
