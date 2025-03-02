import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/ui/screens/edit_profile/edit_profile_controller.dart';
import 'package:on_time/ui/widgets/text_input.dart';
import 'package:random_avatar/random_avatar.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

  Color _getFocusColor(FocusNode focusNode) {
    return focusNode.hasFocus ? const Color(0xFF4098AA) : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Edit Profile",
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
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: const Color(0xFF4098AA),
                          width: 3,
                        ),
                      ),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: controller.imageFile == null
                            ? RandomAvatar('saytoonz',
                                fit: BoxFit.cover,
                                trBackground: true,
                                height: 50,
                                width: 50)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  controller.imageFile!,
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4098AA),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Select an Option",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFE8F2F4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        onPressed:
                                            controller.pickImageFromGallery,
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.photo_library_rounded,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Pick from Gallery",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFE8F2F4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        onPressed:
                                            controller.captureImageWithCamera,
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.photo_camera_rounded,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Capture from Camera",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.photo_camera_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
                            ? CircularProgressIndicator()
                            : Text(
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
