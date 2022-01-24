import 'package:flutter/material.dart';
import '../pages/search_page.dart';
import '../styles.dart';

buildDefaultAppBar(BuildContext context) {
  return AppBar(
    title: Text("CityXplorer"),
    centerTitle: true,
    backgroundColor: Styles.mainBackgroundColor,
    actions: [
      // Navigate to the Search Screen
      IconButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => SearchPage())),
          icon: Icon(Icons.search))
    ],
  );
}
