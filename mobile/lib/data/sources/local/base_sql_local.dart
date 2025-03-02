import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:on_time/data/models/attendance_model.dart';
import 'package:on_time/data/sources/local/dao/attendance_dao.dart';
import 'package:on_time/data/sources/local/tables/attendance_table.dart';
import 'package:path_provider/path_provider.dart';

part 'base_sql_local.g.dart';

@DriftDatabase(tables: [AttendanceTable], daos: [AttendanceDao])
class BaseSqlLocal extends _$BaseSqlLocal {
  BaseSqlLocal() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'ontime.db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
