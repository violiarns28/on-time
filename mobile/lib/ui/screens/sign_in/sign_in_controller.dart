import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/core/routes/app_pages.dart';
import 'package:on_time/data/models/auth_model.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:on_time/data/sources/remote/auth_remote.dart';
import 'package:on_time/utils/logger.dart';

class SignInController extends GetxController {
  final authRemote = Get.find<AuthRemote>();
  final userDao = Get.find<UserDao>();

  final _emailController = Rx(TextEditingController(text: 'john@gmail.com'));
  TextEditingController get emailController => _emailController.value;
  final _passwordController = Rx(TextEditingController(text: 'password'));
  TextEditingController get passwordController => _passwordController.value;

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
    emailController.dispose();
    passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    super.onClose();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  void signIn() async {
    _emailFocusNode.value.unfocus();
    _passwordFocusNode.value.unfocus();
    _isLoading.value = true;
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
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success',
            message: 'Welcome back, ${response.name}',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(Get.context!)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
      } else {
        throw Exception('Something went wrong');
      }
    } on Exception catch (e, st) {
      log.e(e.toString(), stackTrace: st);

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: e.toString(),
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(Get.context!)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } finally {
      _isLoading.value = false;
    }
  }
}
