import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _oldPasswordFocusNode = FocusNode();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isOldPasswordVisible = false;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() => setState(() {}));
    _newPasswordFocusNode.addListener(() => setState(() {}));
    _confirmPasswordFocusNode.addListener(() => setState(() {}));
    _oldPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _oldPasswordFocusNode.dispose();
    super.dispose();
  }

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
                        child: _selectedImage == null
                            ? RandomAvatar('saytoonz',
                                fit: BoxFit.cover,
                                trBackground: true,
                                height: 50,
                                width: 50)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  _selectedImage!,
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
                                        onPressed: () {
                                          _pickImageFromGallery();
                                        },
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
                                        onPressed: () {
                                          _captureImageWithCamera();
                                        },
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
                    _buildTextField(
                      focusNode: _nameFocusNode,
                      label: "Name",
                      hint: "Enter your name",
                      icon: Icons.person_2_rounded,
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      focusNode: _newPasswordFocusNode,
                      label: "New Password",
                      hint: "Enter your new password",
                      icon: Icons.lock_rounded,
                      isPassword: true,
                      isPasswordVisible: _isNewPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      focusNode: _confirmPasswordFocusNode,
                      label: "Confirm Password",
                      hint: "Confirm your new password",
                      icon: Icons.lock_rounded,
                      isPassword: true,
                      isPasswordVisible: _isConfirmPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      focusNode: _oldPasswordFocusNode,
                      label: "Old Password",
                      hint: "Enter your old password",
                      icon: Icons.lock_rounded,
                      isPassword: true,
                      isPasswordVisible: _isOldPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isOldPasswordVisible = !_isOldPasswordVisible;
                        });
                      },
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
                    child: ElevatedButton(
                      onPressed: () {
                        Get.snackbar(
                          "",
                          "",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.transparent,
                          messageText: const AwesomeSnackbarContent(
                            title: "Success",
                            message:
                                "Your changes have been saved successfully!",
                            contentType: ContentType.success,
                          ),
                          duration: const Duration(seconds: 2),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFF4098AA)),
                      ),
                      child: const Text(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? toggleVisibility,
  }) {
    return TextFormField(
      focusNode: focusNode,
      obscureText: isPassword ? !isPasswordVisible : false,
      keyboardType:
          isPassword ? TextInputType.visiblePassword : TextInputType.text,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Color(0xFF4098AA), width: 2.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Container(
          width: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: _getFocusColor(focusNode),
              ),
              const SizedBox(width: 12),
              Container(
                height: 24,
                width: 1,
                color: _getFocusColor(focusNode),
              ),
            ],
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 60),
        labelText: label,
        labelStyle: TextStyle(
          color: _getFocusColor(focusNode),
          fontWeight: FontWeight.w500,
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: toggleVisibility,
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: _getFocusColor(focusNode),
                ),
              )
            : null,
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      Navigator.pop(context);
      _showImagePreviewDialog(File(returnedImage.path));
    }
  }

  Future _captureImageWithCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      Navigator.pop(context);
      _selectedImage = File(returnedImage!.path);
    });
  }

  void _showImagePreviewDialog(File imageFile) {
    showDialog(
      context: context,
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
                setState(() {
                  _selectedImage = imageFile;
                });
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
