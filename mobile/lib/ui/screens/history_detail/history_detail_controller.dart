import 'dart:async';
import 'package:get/get.dart';
import 'package:on_time/data/models/attendance_model.dart';
import 'package:on_time/data/sources/local/dao/attendance_dao.dart';
import 'package:on_time/data/sources/remote/attendance_remote.dart';

class HistoryDetailController extends GetxController {
  final _attendanceDao = Get.find<AttendanceDao>();
  final _attendanceRemote = Get.find<AttendanceRemote>();
  late final StreamController<List<AttendanceModel>> _attendancesController;

  Stream<List<AttendanceModel>> get attendancesStream =>
      _attendancesController.stream;

  Timer? scheduler;

  @override
  Future<void> onInit() async {
    super.onInit();

    _attendancesController =
        StreamController<List<AttendanceModel>>.broadcast();

    await _attendanceRemote.onInit();

    _listenToAttendances();
    await _fetchAttendances();

    scheduleAttendance();
  }

  @override
  void onClose() {
    _attendanceRemote.onClose();
    _attendancesController.close();
    scheduler?.cancel();
    super.onClose();
  }

  void _listenToAttendances() {
    _attendanceDao.watchAttendances().listen((data) {
      if (!_attendancesController.isClosed) {
        _attendancesController.add(data);
      }
    }, onError: (error) {
      print("Error listening to attendances: $error");
    });
  }

  Future<void> _fetchAttendances() async {
    await _attendanceRemote.getAttendances();
  }

  void scheduleAttendance() {
    scheduler = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _fetchAttendances();
    });
  }
}
