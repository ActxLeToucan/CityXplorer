import 'package:cityxplorer/styles.dart';
import 'package:flutter/material.dart';

enum HintPosition { above, inside, swap }

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final HintPosition hintPosition;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final TextInputAction? inputAction;
  final IconData? icon;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Color? textColor;
  final double? textSize;
  final Color? hintColor;
  final Color? fieldColor;
  final Color? borderColor;
  final bool withoutBorder;
  final bool withBottomSpace;
  final bool autoFocus;

  const InputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.hintPosition,
    this.keyboardType,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputAction,
    this.icon,
    this.onSubmitted,
    this.onChanged,
    this.validator,
    this.textColor,
    this.textSize,
    this.hintColor,
    this.fieldColor,
    this.borderColor,
    this.withoutBorder = false,
    this.withBottomSpace = false,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextFormField field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: inputAction,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      validator: validator,
      autofocus: autoFocus,
      style: TextStyle(color: textColor, fontSize: textSize),
      decoration: InputDecoration(
        fillColor: fieldColor,
        filled: fieldColor != null ? true : null,
        labelText: hintPosition == HintPosition.swap ? hintText : null,
        labelStyle: TextStyle(color: textColor ?? hintColor),
        alignLabelWithHint: true,
        floatingLabelStyle: TextStyle(color: hintColor ?? Styles.mainColor),
        hintText: hintPosition == HintPosition.inside ? hintText : null,
        hintStyle: TextStyle(color: hintColor, fontSize: textSize),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: withoutBorder
                ? BorderSide.none
                : BorderSide(color: borderColor ?? const Color(0xFF9A9A9A))),
        prefixIcon: icon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(icon, size: 28, color: textColor),
              )
            : null,
      ),
    );

    List<Widget> elements = [];
    if (hintPosition == HintPosition.above) {
      elements.add(Text(hintText,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: hintColor ?? const Color(0xFF404040))));
      elements.add(const SizedBox(height: 8));
    }
    elements.add(field);
    if (withBottomSpace) {
      elements.add(const SizedBox(height: 24));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: elements,
    );
  }
}

class InputLogin extends InputField {
  InputLogin({
    Key? key,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputAction? inputAction,
    void Function(String)? onSubmitted,
    String? Function(String?)? validator,
    bool withBottomSpace = false,
  }) : super(
            key: key,
            controller: controller,
            hintText: hintText,
            hintPosition: HintPosition.inside,
            keyboardType:
                isPassword ? TextInputType.visiblePassword : TextInputType.name,
            obscureText: isPassword,
            inputAction: inputAction,
            icon: icon,
            onSubmitted: onSubmitted,
            validator: validator,
            textColor: Styles.loginTextColor,
            textSize: Styles.loginTextSize,
            hintColor: Styles.loginTextColor,
            fieldColor: Styles.loginFieldColor,
            withoutBorder: true,
            withBottomSpace: withBottomSpace);
}
