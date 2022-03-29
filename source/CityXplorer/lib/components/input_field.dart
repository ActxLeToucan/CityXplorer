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

enum ButtonType { big, small }

class Button extends StatefulWidget {
  final ButtonType type;
  final String? text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? contentColor;
  final bool withLoadingAnimation;
  final double? fontSize;
  final Function? onPressed;
  final bool underlined;
  bool _isLoading = false;

  Button({
    Key? key,
    required this.type,
    this.backgroundColor = Styles.mainColor,
    this.withLoadingAnimation = false,
    this.onPressed,
    this.text,
    this.icon,
    this.contentColor = Colors.black,
    this.fontSize,
    this.underlined = false,
  }) : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Widget button;

    Widget content = const Text("");
    if (widget.text != null) {
      content = Text(
        widget.text ?? "",
        style: TextStyle(color: widget.contentColor, fontSize: widget.fontSize),
      );
    } else if (widget.icon != null) {
      content = Icon(widget.icon, color: widget.contentColor);
    }

    Widget child = isLoading
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: widget.contentColor,
            ))
        : content;

    switch (widget.type) {
      case ButtonType.big:
        button = MaterialButton(
          onPressed: actionOnPressed,
          color: widget.backgroundColor,
          child: child,
        );
        break;
      case ButtonType.small:
        button = TextButton(
            onPressed: actionOnPressed,
            child: widget.underlined
                ? Container(
                    child: child,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: widget.contentColor ?? Colors.black))))
                : child);
        break;
    }
    if (widget.withLoadingAnimation) {
      button = IgnorePointer(
        ignoring: isLoading,
        child: button,
      );
    }
    return widget.type == ButtonType.big
        ? SizedBox(child: button, height: 60.0, width: double.infinity)
        : button;
  }

  Future<void> actionOnPressed() async {
    if (widget.onPressed == null) return;

    if (widget.withLoadingAnimation) setState(() => isLoading = true);
    await widget.onPressed!();
    if (widget.withLoadingAnimation) setState(() => isLoading = false);
  }
}

class ButtonLogin extends Button {
  ButtonLogin({
    Key? key,
    required ButtonType type,
    required String text,
    required Function onPressed,
  }) : super(
          key: key,
          type: type,
          text: text,
          fontSize: Styles.loginTextSize,
          contentColor: Colors.white,
          backgroundColor:
              type == ButtonType.big ? const Color(0xFF22402F) : null,
          withLoadingAnimation: type == ButtonType.big,
          underlined: type == ButtonType.small,
          onPressed: onPressed,
        );
}
