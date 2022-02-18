import 'package:flutter/material.dart';
import '../styles.dart';

buildDefaultAppBar(BuildContext context) {
  return AppBar(
    title: const Text("CityXplorer"),
    centerTitle: true,
    backgroundColor: Styles.mainColor,
    actions: [
      // Navigate to the Search Screen
      IconButton(
          onPressed: () => Navigator.pushNamed(context, "searchPage"),
          icon: const Icon(Icons.search))
    ],
  );
}
