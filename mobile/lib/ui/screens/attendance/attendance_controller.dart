import 'dart:async';

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

  final _attendances = <AttendanceModel>[].obs;
  List<AttendanceModel> get attendances => _attendances;

  Timer? _allAttendanceTimer;
  Timer? _myAttendanceTimer;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final clockInAttendance = Rx<AttendanceModel?>(null);
  final clockOutAttendance = Rx<AttendanceModel?>(null);

  String get latestClockIn {
    final attendance = clockInAttendance.value;
    if (attendance == null || attendance.type != AttendanceType.CLOCK_IN) {
      return "--:--";
    }
    return _formatTime(attendance.timestamp);
  }

  String get latestClockOut {
    final attendance = clockOutAttendance.value;
    if (attendance == null || attendance.type != AttendanceType.CLOCK_OUT) {
      return "--:--";
    }
    return _formatTime(attendance.timestamp);
  }

  bool get isAlreadyClockIn => clockInAttendance.value != null;
  bool get isAlreadyClockOut => clockOutAttendance.value != null;
  bool get isAlreadyClockInAndOut => isAlreadyClockIn && isAlreadyClockOut;

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
      if (response.type == AttendanceType.CLOCK_IN) {
        clockInAttendance.value = response;
      }
    } on Exception catch (e, st) {
      // log.e('Failed to fetch clock-in', error: e, stackTrace: st);
    }
  }

  Future<void> _fetchMyLatestClockOutAttendance() async {
    log.i('[AttendanceController] Fetching latest clock-out');
    try {
      final response = await _attendanceRemote
          .getMyLatestAttendance(AttendanceType.CLOCK_OUT);
      if (response.type == AttendanceType.CLOCK_OUT) {
        clockOutAttendance.value = response;
      }
    } on Exception catch (e, st) {
      // log.e('Failed to fetch clock-out', error: e, stackTrace: st);
    }
  }

  String _formatTime(int timestamp) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Error',
        'Location services are disabled on your device',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Error',
          'Location permissions are denied',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Error',
        'Location permissions are permanently denied, we cannot request permissions',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  Future<void> saveAttendance() async {
    if (isAlreadyClockIn && isAlreadyClockOut) {
      Get.snackbar(
        'Error',
        'You have already clocked in and out today',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final isLocationPermissionGranted = await _handleLocationPermission();
    if (!isLocationPermissionGranted) {
      return;
    }

    try {
      _isLoading.value = true;
      final position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      final attendanceType =
          isAlreadyClockIn ? AttendanceType.CLOCK_OUT : AttendanceType.CLOCK_IN;

      final response = await _attendanceRemote.saveAttendance(
        MarkAttendanceRequest(
          latitude: position.latitude,
          longitude: position.longitude,
          type: attendanceType,
          deviceId: await _userDao.getDeviceId() ?? 'unknown',
        ),
      );

      if (response is AttendanceModel) {
        Get.snackbar(
          'Success',
          '${attendanceType == AttendanceType.CLOCK_IN ? 'Clock-in' : 'Clock-out'} saved successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        if (attendanceType == AttendanceType.CLOCK_IN) {
          clockInAttendance.value = response;
        } else {
          clockOutAttendance.value = response;
        }

        _fetchAttendances();
      } else {
        Get.snackbar(
          'Error',
          'Failed to save attendance',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, st) {
      log.e('Error saving attendance', error: e, stackTrace: st);
      Get.snackbar(
        'Error',
        'An error occurred while saving attendance',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
