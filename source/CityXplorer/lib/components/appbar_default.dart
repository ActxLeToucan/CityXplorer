import 'package:flutter/material.dart';
import '../styles.dart';

buildDefaultAppBar(BuildContext context) {
  return AppBar(
    title: Text("CityXplorer"),
    centerTitle: true,
    backgroundColor: Styles.mainBackgroundColor,
    actions: [
      // Navigate to the Search Screen
      IconButton(
          onPressed: () => Navigator.pushNamed(context, "searchPage"),
          icon: Icon(Icons.search))
    ],
  );
}
