import 'package:flutter/material.dart';

class Styles {
  // global
  static const Color mainColor = Color(0xFF388E3C);
  static const TextStyle textStyleLink = TextStyle(color: Colors.green);

  // login
  static final Color? backgroundColorInput = Colors.grey[500]?.withOpacity(0.5);
  static const Color loginTextColor = Colors.white;
  static const double loginTextSize = 22.0;
  static const TextStyle textStyleInput = TextStyle(
      color: Styles.loginTextColor,
      fontSize: Styles.loginTextSize,
      height: 1.5);
  static const TextStyle textStyleLoginButton =
      TextStyle(color: Styles.loginTextColor, fontSize: Styles.loginTextSize);
  static const double widthElementLogin = 0.8;
  static const double heightElementLogin = 0.08;
  // camera
  static const int maxPhotos = 5;
}
