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
  final _nameController = Rx(TextEditingController());
  TextEditingController get nameController => _nameController.value;

  final _emailController = Rx(TextEditingController());
  TextEditingController get emailController => _emailController.value;
  final _passwordController = Rx(TextEditingController());
  TextEditingController get passwordController => _passwordController.value;

  final _nameFocusNode = Rx(FocusNode());
  FocusNode get nameFocusNode => _nameFocusNode.value;
  final _emailFocusNode = Rx(FocusNode());
  FocusNode get emailFocusNode => _emailFocusNode.value;
  final _passwordFocusNode = Rx(FocusNode());
  FocusNode get passwordFocusNode => _passwordFocusNode.value;

  final _isPasswordVisible = false.obs;
  bool get isPasswordVisible => _isPasswordVisible.value;
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    authRemote.onInit();
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  void signUp() async {
    _isLoading.value = true;
    log.d("[SignUpController] signUp");
    try {
      final response = await authRemote.register(
        RegisterRequest(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          deviceId: (await userDao.getDeviceId() ?? ''),
        ),
      );
      if (response.createdAt != null) {
        Get.snackbar(
          'Success',
          "You've successfully registered",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
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
    } finally {
      _isLoading.value = false;
    }
  }
}
