import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_time/core/routes/routes.dart';
import 'package:on_time/data/models/user_model.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:on_time/data/sources/remote/profile_remote.dart';
import 'package:on_time/utils/logger.dart';

class EditProfileController extends GetxController {
  final ProfileRemote profileRemote = Get.find();
  final UserDao userDao = Get.find();

  File? imageFile;

  late TextEditingController nameController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  late FocusNode nameFocusNode;
  late FocusNode oldPasswordFocusNode;
  late FocusNode newPasswordFocusNode;
  late FocusNode confirmPasswordFocusNode;

  late UserModel user;

  final _isPasswordVisible = false.obs;
  bool get isPasswordVisible => _isPasswordVisible.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  Future<void> onInit() async {
    final findMe = await userDao.getUser();
    if (findMe != null) {
      user = findMe;
    } else {
      return Get.offAllNamed(Routes.SIGN_IN);
    }
    nameController = TextEditingController(text: user.name);
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    nameFocusNode = FocusNode();
    oldPasswordFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();

    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    nameFocusNode.dispose();
    oldPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  void updateProfile() async {
    _isLoading.value = true;
    log.d("[EditProfileController] updateProfile");
    try {
      final response = await profileRemote.updateProfile(
        UpdateProfileRequest(
          id: user.id,
          name: nameController.text,
          email: user.email,
          deviceId: user.deviceId,
          password: newPasswordController.text,
        ),
      );
      if (response.createdAt != null) {
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on Exception catch (e, st) {
      log.e(e.toString(), stackTrace: st);
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      Get.back();
      imageFile = File(returnedImage.path);
      _showImagePreviewDialog(imageFile!);
    }
  }

  Future captureImageWithCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    Get.back();
    imageFile = File(returnedImage!.path);
  }

  void _showImagePreviewDialog(File imageFile) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Preview Image"),
          content: Image.file(imageFile),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
