import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../router/delegate.dart';

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

namedAppBar(BuildContext context, String titre) {
  return AppBar(
    title: Text(titre),
    centerTitle: true,
  );
}

transparentAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.black,
  );
}
