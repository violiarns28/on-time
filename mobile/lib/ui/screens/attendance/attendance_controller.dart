import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_time/data/models/attendance_model.dart';
import 'package:on_time/data/sources/local/dao/attendance_dao.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:on_time/data/sources/remote/attendance_remote.dart';
import 'package:on_time/utils/logger.dart';

class AttendanceController extends GetxController {
  final _attendanceDao = Get.find<AttendanceDao>();
  final _attendanceRemote = Get.find<AttendanceRemote>();
  final _userDao = Get.find<UserDao>();
  final LatLng center = const LatLng(-7.341591059504343, 112.736106577182336);

  GoogleMapController? mapController;
  final now = DateTime.now();

  final _attendances = <AttendanceModel>[].obs;
  List<AttendanceModel> get attendances => _attendances;

  Timer? _allAttendanceTimer;
  Timer? _myAttendanceTimer;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final todayClockIn = Rx<AttendanceModel?>(null);
  final todayClockOut = Rx<AttendanceModel?>(null);

  String get todayClockInTime {
    final attendance = todayClockIn.value;
    if (attendance == null || attendance.type != AttendanceType.CLOCK_IN) {
      return "--:--";
    }
    return _formatTime(attendance.timestamp);
  }

  String get todayClockOutTime {
    final attendance = todayClockOut.value;
    if (attendance == null || attendance.type != AttendanceType.CLOCK_OUT) {
      return "--:--";
    }
    return _formatTime(attendance.timestamp);
  }

  bool get isTodayClockIn => todayClockIn.value != null;
  bool get isTodayClockOut => todayClockOut.value != null;
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

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
    log.i('[AttendanceController] Fetching latest clock-in');
    try {
      final response = await _attendanceRemote
          .getMyLatestAttendance(AttendanceType.CLOCK_IN);
      final date = DateTime.fromMillisecondsSinceEpoch(response.timestamp);
      if (response.type == AttendanceType.CLOCK_IN && date.day == now.day) {
        todayClockIn.value = response;
      }
    } on Exception catch (e) {
      // log.e('Failed to fetch clock-in', error: e, stackTrace: st);
    }
  }

  Future<void> _fetchMyLatestClockOutAttendance() async {
    log.i('[AttendanceController] Fetching latest clock-out');
    try {
      final response = await _attendanceRemote
          .getMyLatestAttendance(AttendanceType.CLOCK_OUT);
      final date = DateTime.fromMillisecondsSinceEpoch(response.timestamp);
      if (response.type == AttendanceType.CLOCK_OUT && date.day == now.day) {
        todayClockOut.value = response;
      }
    } on Exception catch (e) {
      // log.e('Failed to fetch clock-out', error: e, stackTrace: st);
    }
  }

  String _formatTime(int timestamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // activate location service
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        _showSnackBar(
          context,
          'Location Service Error',
          'Location services are disabled',
          ContentType.warning,
        );
        return false;
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar(
          context,
          'Permission Denied',
          'Location permissions are denied',
          ContentType.warning,
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar(
        context,
        'Permission Error',
        'Location permissions are permanently denied',
        ContentType.failure,
      );
      return false;
    }
    return true;
  }

  Future<void> saveAttendance(BuildContext context) async {
    if (todayClockIn.value != null && todayClockOut.value != null) {
      _showSnackBar(
        context,
        'Attendance Error',
        'You have already clocked in and out today',
        ContentType.failure,
      );
      return;
    }

    final isLocationPermissionGranted =
        await _handleLocationPermission(context);
    if (!isLocationPermissionGranted) return;

    try {
      _isLoading.value = true;
      final position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      final attendanceType = todayClockIn.value == null
          ? AttendanceType.CLOCK_IN
          : AttendanceType.CLOCK_OUT;

      final response = await _attendanceRemote.saveAttendance(
        MarkAttendanceRequest(
          latitude: position.latitude,
          longitude: position.longitude,
          type: attendanceType,
          deviceId: await _userDao.getDeviceId() ?? 'unknown',
        ),
      );

      if (response is AttendanceModel) {
        _showSnackBar(
          context,
          'Success',
          '${attendanceType == AttendanceType.CLOCK_IN ? 'Clock-in' : 'Clock-out'} saved successfully',
          ContentType.success,
        );

        if (attendanceType == AttendanceType.CLOCK_IN) {
          todayClockIn.value = response;
        } else {
          todayClockOut.value = response;
        }
        _fetchAttendances();
      } else {
        _showSnackBar(
          context,
          'Error',
          'Failed to save attendance',
          ContentType.failure,
        );
      }
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
