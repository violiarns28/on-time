import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_time/core/routes/routes.dart';
import 'package:on_time/data/models/user_model.dart';
import 'package:on_time/data/sources/local/dao/user_dao.dart';
import 'package:on_time/data/sources/remote/profile_remote.dart';
import 'package:on_time/ui/screens/home/home_controller.dart';
import 'package:on_time/ui/screens/profile/profile_controller.dart';
import 'package:on_time/utils/logger.dart';

class EditProfileController extends GetxController {
  final profileRemote = Get.find<ProfileRemote>();
  final userDao = Get.find<UserDao>();

  File? imageFile;

  final _nameController = Rx(TextEditingController());
  TextEditingController get nameController => _nameController.value;
  set nameController(TextEditingController v) => _nameController.value = v;
  final _oldPasswordController = Rx(TextEditingController());
  TextEditingController get oldPasswordController =>
      _oldPasswordController.value;
  final _newPasswordController = Rx(TextEditingController());
  TextEditingController get newPasswordController =>
      _newPasswordController.value;
  final _confirmPasswordController = Rx(TextEditingController());
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController.value;

  final nameFocusNode = FocusNode();
  final oldPasswordFocusNode = FocusNode();
  final newPasswordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  UserModel user = UserModel.placeholder();

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
        user = response;
        Get.find<ProfileController>().user = response;
        Get.find<HomeController>().user = response;

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success',
            message: 'Profile updated successfully!',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(Get.context!)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
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
