import 'package:flutter/material.dart';

import '../styles.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    required this.controller,
    required this.icon,
    required this.hint,
    this.inputType,
    this.inputAction,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final TextInputType? inputType;
  final TextInputAction? inputAction;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: size.height * Styles.heightElementLogin,
        width: size.width * Styles.widthElementLogin,
        decoration: BoxDecoration(
          color: Styles.backgroundColorInput,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(
                  icon,
                  size: 28,
                  color: Styles.loginTextColor,
                ),
              ),
              hintText: hint,
              hintStyle: Styles.textStyleInput,
            ),
            obscureText: true,
            style: Styles.textStyleInput,
            keyboardType: inputType,
            textInputAction: inputAction,
          ),
        ),
      ),
    );
  }
}
