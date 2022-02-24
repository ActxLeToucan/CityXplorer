import 'package:flutter/material.dart';

defaultAppBar(BuildContext context) {
  return AppBar(
    title: const Text("CityXplorer"),
    centerTitle: true,
    actions: [
      // Navigate to the Search Screen
      IconButton(
          onPressed: () => Navigator.pushNamed(context, "searchPage"),
          icon: const Icon(Icons.search))
    ],
  );
}

transparentAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.black,
  );
}
