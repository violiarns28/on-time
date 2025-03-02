import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/core/routes/app_pages.dart';
import 'package:on_time/data/models/auth_model.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:on_time/data/sources/remote/auth_remote.dart';
import 'package:on_time/utils/logger.dart';

class SignInController extends GetxController {
  final AuthRemote authRemote = Get.find();
  final UserDao userDao = Get.find();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  var isPasswordVisible = false.obs;

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    authRemote.onInit();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void signIn() async {
    log.d("[SignInController] signIn");
    try {
      final response = await authRemote.login(
        LoginRequest(
          email: emailController.text,
          password: passwordController.text,
          deviceId: (await userDao.getDeviceId() ?? ''),
        ),
      );
      if (response.createdAt != null) {
        Get.snackbar(
          'Success',
          'Welcome back, ${response.name}',
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
