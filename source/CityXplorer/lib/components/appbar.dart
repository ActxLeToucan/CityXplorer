import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../router/delegate.dart';
import '../styles.dart';

defaultAppBar(BuildContext context) {
  final routerDelegate = Get.find<MyRouterDelegate>();
  return AppBar(
    title: const Text("CityXplorer"),
    centerTitle: true,
    actions: [
      // Navigate to the Search Screen
      IconButton(
          onPressed: () => routerDelegate.pushPage(name: '/search'),
          icon: const Icon(Icons.search))
    ],
  );
}

namedAppBar(BuildContext context, String titre, {bool centerTitle = true}) {
  return AppBar(
    title: Text(titre),
    centerTitle: centerTitle,
  );
}

transparentAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor:
        Styles.darkMode ? Styles.darkTextColor : Styles.lightTextColor,
  );
}
