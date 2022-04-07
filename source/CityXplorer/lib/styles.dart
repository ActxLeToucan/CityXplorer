import 'package:flutter/material.dart';

class Styles {
  static bool darkMode = true;

  static const Color darkBackground = Colors.black;
  static const Color lightBackground = Colors.white;
  static const Color darkTextColor = Colors.white;
  static const Color lightTextColor = Colors.black;
  static const Color lightElement = Colors.white;
  static const Color darkElement = Color(0xFF202020);

  // global
  static const Color homeColor = Colors.lightGreen;
  static const Color mainColor = Color(0xFF388E3C);
  static const Color darkRed = Color(0xFFCF0000);
  static const Color linkColor = mainColor;

  // login
  static final Color? loginFieldColor = Colors.grey[500]?.withOpacity(0.5);
  static const Color loginTextColor = Colors.white;
  static const double bigButtonTextSize = 22.0;
  static const TextStyle textStyleInput = TextStyle(
      color: Styles.loginTextColor,
      fontSize: Styles.bigButtonTextSize,
      height: 1.5);
  static const TextStyle textStyleLoginButton = TextStyle(
      color: Styles.loginTextColor, fontSize: Styles.bigButtonTextSize);
  static const double widthElementLogin = 0.8;
  static const double heightElementLogin = 0.08;
  static const textCTAButton = TextStyle(
    fontSize: 22.0,
    color: Colors.white,
  );
}
