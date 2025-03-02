import 'package:drift/drift.dart';
import 'package:on_time/data/models/attendance_model.dart';

class AttendanceTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  IntColumn get type => intEnum<AttendanceType>()();
  TextColumn get date => text()();
  Int64Column get timestamp => int64()();
  TextColumn get hash => text()();
  TextColumn get previousHash => text()();
  IntColumn get nonce => integer()();
}
