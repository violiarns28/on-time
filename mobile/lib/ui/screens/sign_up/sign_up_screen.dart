import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_time/core/routes/app_pages.dart';
import 'package:on_time/ui/screens/sign_up/sign_up_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() => setState(() {}));
    _emailFocusNode.addListener(() => setState(() {}));

    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  Color _getFocusColor(FocusNode focusNode) {
    return focusNode.hasFocus ? const Color(0xFF4098AA) : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    const imageSize = 286.0;
    final formHeight = height - imageSize - 48;
    return GetBuilder<SignUpController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFF96D4E1),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                      width: imageSize,
                      height: imageSize,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/sign_up.png'),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    height: formHeight,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          "Just a few quick things to get started",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4098AA).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Form(
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
                                  focusNode: _emailFocusNode,
                                  label: "Email",
                                  hint: "Enter your email",
                                  icon: Icons.mail_rounded,
                                ),
                                const SizedBox(height: 16.0),
                                _buildTextField(
                                  focusNode: _passwordFocusNode,
                                  label: "Password",
                                  hint: "Enter your password",
                                  icon: Icons.lock_rounded,
                                  isPassword: true,
                                  isPasswordVisible: _isPasswordVisible,
                                  toggleVisibility: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Center(
                          child: Material(
                            borderRadius: BorderRadius.circular(24),
                            child: SizedBox(
                              width: 200,
                              height: 42,
                              child: ElevatedButton(
                                onPressed: controller.signUp,
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          const Color(0xFF4098AA)),
                                ),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.SIGN_IN);
                              },
                              child: const Text(
                                " Sign In",
                                style: TextStyle(
                                    color: Color(0xFF4952F3),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
}
