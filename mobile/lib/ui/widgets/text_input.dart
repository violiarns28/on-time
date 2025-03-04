import 'package:flutter/material.dart';

class TextInput extends TextFormField {
  static Color _getFocusColor(FocusNode focusNode) {
    return focusNode.hasFocus ? const Color(0xFF4098AA) : Colors.black;
  }

  TextInput({
    super.key,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? toggleVisibility,
    TextInputAction textInputAction = TextInputAction.next,
    required TextEditingController controller,
  }) : super(
          focusNode: focusNode,
          textInputAction: textInputAction,
          obscureText: isPassword ? !isPasswordVisible : false,
          keyboardType:
              isPassword ? TextInputType.visiblePassword : TextInputType.text,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide:
                  const BorderSide(color: Color(0xFF4098AA), width: 2.0),
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
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: _getFocusColor(focusNode),
                    ),
                  )
                : null,
          ),
          controller: controller,
        );
}
