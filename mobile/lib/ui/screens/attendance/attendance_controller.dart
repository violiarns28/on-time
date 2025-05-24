import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/data/models/attendance_model.dart';
import 'package:on_time/data/sources/local/dao/attendance_dao.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:on_time/data/sources/remote/attendance_remote.dart';
import 'package:on_time/utils/logger.dart';

class AttendanceController extends GetxController {
  final _attendanceDao = Get.find<AttendanceDao>();
  final _attendanceRemote = Get.find<AttendanceRemote>();
  final _userDao = Get.find<UserDao>();

  final now = DateTime.now();

  final _attendances = <AttendanceModel>[].obs;
  List<AttendanceModel> get attendances => _attendances;

  Timer? _allAttendanceTimer;
  Timer? _myAttendanceTimer;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _todayClockIn = Rx<AttendanceModel?>(null);
  AttendanceModel? get todayClockIn => _todayClockIn.value;
  set todayClockIn(AttendanceModel? value) => _todayClockIn.value = value;

  final _todayClockOut = Rx<AttendanceModel?>(null);
  AttendanceModel? get todayClockOut => _todayClockOut.value;
  set todayClockOut(AttendanceModel? value) => _todayClockOut.value = value;

  String get todayClockInTime {
    final attendance = todayClockIn;
    if (attendance == null || attendance.type != AttendanceType.CLOCK_IN) {
      return "--:--";
    }
    return _formatTime(attendance.timestamp);
  }

  String get todayClockOutTime {
    final attendance = todayClockOut;
    if (attendance == null || attendance.type != AttendanceType.CLOCK_OUT) {
      return "--:--";
    }
    return _formatTime(attendance.timestamp);
  }

  bool get isTodayClockIn => todayClockIn != null;
  bool get isTodayClockOut => todayClockOut != null;
  bool get isTodayClockInAndOut => isTodayClockIn && isTodayClockOut;

  @override
  Future<void> onInit() async {
    super.onInit();

    await _attendanceRemote.onInit();
    _initAttendancesStream();

    await Future.wait([
      _fetchAttendances(),
      _fetchMyLatestClockInAttendance(),
      _fetchMyLatestClockOutAttendance(),
    ]);

    _schedulePeriodicUpdates();
  }

  @override
  void onClose() {
    _attendanceRemote.onClose();
    _allAttendanceTimer?.cancel();
    _myAttendanceTimer?.cancel();
    super.onClose();
  }

  void _initAttendancesStream() {
    final attendancesStream = _attendanceDao.watchAttendances();
    attendancesStream.listen((attendances) {
      _attendances.value = attendances;
    });
  }

  Future<void> _fetchAttendances() async {
    try {
      await _attendanceRemote.getAttendances();
    } catch (e, st) {
      log.e('Failed to fetch attendances', error: e, stackTrace: st);
    }
  }

  void _schedulePeriodicUpdates() {
    _allAttendanceTimer =
        Timer.periodic(const Duration(seconds: 3), (_) => _fetchAttendances());

    _myAttendanceTimer = Timer.periodic(
        const Duration(seconds: 3), (_) => _refreshMyAttendanceStatus());
  }

  Future<void> _refreshMyAttendanceStatus() async {
    await Future.wait([
      _fetchMyLatestClockInAttendance(),
      _fetchMyLatestClockOutAttendance(),
    ]);
  }

  Future<void> _fetchMyLatestClockInAttendance() async {
    try {
      final response = await _attendanceRemote
          .getMyLatestAttendance(AttendanceType.CLOCK_IN);
      final date = DateTime.fromMillisecondsSinceEpoch(response.timestamp);
      if (response.type == AttendanceType.CLOCK_IN && date.day == now.day) {
        todayClockIn = response;
      }
    } on Exception catch (_) {}
  }

  Future<void> _fetchMyLatestClockOutAttendance() async {
    try {
      final response = await _attendanceRemote
          .getMyLatestAttendance(AttendanceType.CLOCK_OUT);
      final date = DateTime.fromMillisecondsSinceEpoch(response.timestamp);
      if (response.type == AttendanceType.CLOCK_OUT && date.day == now.day) {
        todayClockOut = response;
      }
    } on Exception catch (_) {}
  }

  String _formatTime(int timestamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> saveAttendance(BuildContext context) async {
    if (todayClockIn != null && todayClockOut != null) {
      _showSnackBar(
        context,
        'Attendance Error',
        'You have already clocked in and out today',
        ContentType.failure,
      );
      return;
    }

    try {
      _isLoading.value = true;

      final attendanceType = todayClockIn == null
          ? AttendanceType.CLOCK_IN
          : AttendanceType.CLOCK_OUT;

      final response = await _attendanceRemote.saveAttendance(
        MarkAttendanceRequest(
          type: attendanceType,
        ),
      );

      _showSnackBar(
        context,
        'Success',
        '${attendanceType == AttendanceType.CLOCK_IN ? 'Clock-in' : 'Clock-out'} saved successfully',
        ContentType.success,
      );

      if (response != null) {
        if (attendanceType == AttendanceType.CLOCK_IN) {
          todayClockIn = response;
        } else {
          todayClockOut = response;
        }
      }

      _fetchAttendances();
    } catch (e, st) {
      log.e('Error saving attendance', error: e, stackTrace: st);
      _showSnackBar(
        context,
        'Error',
        'An error occurred while saving attendance',
        ContentType.failure,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _showSnackBar(
      BuildContext context, String title, String message, ContentType type) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
