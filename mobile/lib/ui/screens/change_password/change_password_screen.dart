import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/ui/screens/change_password/change_password_controller.dart';
import 'package:on_time/ui/widgets/text_input.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late ChangePasswordController controller;

  @override
  void initState() {
    Get.put(ChangePasswordController());
    controller = Get.find<ChangePasswordController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Change Password",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    Obx(
                      () => TextInput(
                        focusNode: controller.nameFocusNode,
                        controller: controller.nameController,
                        label: "Name",
                        hint: "Enter your name",
                        icon: Icons.person_2_rounded,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Obx(
                      () => TextInput(
                        focusNode: controller.newPasswordFocusNode,
                        controller: controller.newPasswordController,
                        label: "New Password",
                        hint: "Enter your new password",
                        icon: Icons.lock_rounded,
                        isPassword: true,
                        isPasswordVisible: controller.isPasswordVisible,
                        toggleVisibility: controller.togglePasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Obx(
                      () => TextInput(
                        focusNode: controller.confirmPasswordFocusNode,
                        controller: controller.confirmPasswordController,
                        label: "Confirm Password",
                        hint: "Confirm your new password",
                        icon: Icons.lock_rounded,
                        isPassword: true,
                        isPasswordVisible: controller.isPasswordVisible,
                        toggleVisibility: controller.togglePasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Obx(
                      () => TextInput(
                        focusNode: controller.oldPasswordFocusNode,
                        controller: controller.oldPasswordController,
                        label: "Old Password",
                        hint: "Enter your old password",
                        icon: Icons.lock_rounded,
                        isPassword: true,
                        isPasswordVisible: controller.isPasswordVisible,
                        toggleVisibility: controller.togglePasswordVisibility,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Center(
                child: Material(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    width: 200,
                    height: 42,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading
                            ? null
                            : controller.updateProfile,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFF4098AA)),
                        ),
                        child: controller.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                "Save Changes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
