import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;

  var isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
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
}
