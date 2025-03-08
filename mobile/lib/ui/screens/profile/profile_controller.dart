import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_time/core/routes/app_pages.dart';
import 'package:on_time/data/models/user_model.dart';
import 'package:on_time/data/sources/local/dao/attendance_dao.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';

class ProfileController extends GetxController {
  final _userDao = Get.find<UserDao>();
  final _attendanceDao = Get.find<AttendanceDao>();

  final _user = Rx(UserModel.placeholder());
  UserModel get user => _user.value;
  set user(UserModel v) => _user.value = v;

  @override
  Future<void> onInit() async {
    final findUser = await _userDao.getUser();
    if (findUser != null) {
      user = findUser;
    } else {
      Get.offAllNamed(Routes.SIGN_IN);
      return;
    }
    super.onInit();
  }

  void copyDeviceId() {
    Clipboard.setData(ClipboardData(text: user.deviceId));

    const snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Device ID Copied',
        message: 'Device ID has been copied to clipboard',
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(Get.context!)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<void> signOut() async {
    await Future.wait([
      _userDao.clearUser(),
      _attendanceDao.clearAttendances(),
    ]);

    const snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Signed Out',
        message: 'You have been signed out successfully.',
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(Get.context!)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    Get.offAllNamed(Routes.SIGN_IN);
  }
}
