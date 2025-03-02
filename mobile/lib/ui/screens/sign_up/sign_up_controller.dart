import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/core/routes/app_pages.dart';
import 'package:on_time/data/models/auth_model.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:on_time/data/sources/remote/auth_remote.dart';
import 'package:on_time/utils/logger.dart';

class SignUpController extends GetxController {
  final AuthRemote authRemote = Get.find();
  final UserDao userDao = Get.find();
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;

  var isPasswordVisible = false.obs;

  @override
  void onInit() {
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();

    authRemote.onInit();
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void signUp() async {
    log.d("[SignUpController] signUp");
    try {
      final response = await authRemote.register(
        RegisterRequest(
          name: name.text,
          email: email.text,
          password: password.text,
          deviceId: (await userDao.getDeviceId() ?? ''),
        ),
      );
      if (response.createdAt != null) {
        Get.snackbar(
          'Success',
          "You've successfully registered",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(Routes.HOME);
      } else {
        throw Exception('Something went wrong');
      }
    } on Exception catch (e, st) {
      log.e(e.toString(), stackTrace: st);
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
