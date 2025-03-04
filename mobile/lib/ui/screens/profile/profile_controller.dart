import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_time/core/routes/app_pages.dart';
import 'package:on_time/data/models/user_model.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';

class ProfileController extends GetxController {
  final _userDao = Get.find<UserDao>();

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
    Get.snackbar('Device ID copied', 'Device ID copied to clipboard');
  }

  Future<void> signOut() async {
    await _userDao.clearUser();
    Get.offAllNamed(Routes.SIGN_IN);
  }
}
