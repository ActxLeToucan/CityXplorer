import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../router/delegate.dart';
import '../styles.dart';

class Description extends StatelessWidget {
  final String description;
  final double? fontSize;
  final double? height;
  final Color defaultColor;

  const Description({
    Key? key,
    required this.description,
    this.fontSize,
    this.height,
    this.defaultColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Get.find<MyRouterDelegate>();

    RegExp regex = RegExp(r"@[\w\-]*");
    List<String> list = description.splitWithDelim(regex);
    List<TextSpan> spans = [];
    list.forEach((element) {
      TextSpan text;
      if (element.startsWith("@")) {
        String pseudo = element.substring(1);
        text = TextSpan(
            text: element,
            style: TextStyle(
                fontSize: fontSize, height: height, color: Styles.linkColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => routerDelegate
                  .pushPage(name: '/user', arguments: {'pseudo': pseudo}));
      } else {
        text = TextSpan(
            text: element,
            style: TextStyle(
                fontSize: fontSize, height: height, color: defaultColor));
      }

      spans.add(text);
    });
    return RichText(text: TextSpan(children: spans));
  }
}

extension RegExpExtension on RegExp {
  List<String> allMatchesWithSep(String input, [int start = 0]) {
    var result = <String>[];
    for (var match in allMatches(input, start)) {
      result.add(input.substring(start, match.start));
      result.add(match[0] ?? "");
      start = match.end;
    }
    result.add(input.substring(start));
    return result;
  }
}

extension StringExtension on String {
  List<String> splitWithDelim(RegExp pattern) =>
      pattern.allMatchesWithSep(this);
}
