import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cityxplorer/pages/create_account.dart';
import 'package:cityxplorer/pages/login_screen.dart';
import 'package:cityxplorer/pages/main_interface.dart';
import 'package:cityxplorer/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';
import 'my_http_overrides.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }

  HttpOverrides.global = MyHttpOverrides();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("token");

  runApp(MaterialApp(
    title: 'CityXplorer',
    home: (token == null ? const LoginScreen() : const MainInterface()),
    routes: {
      'main': (context) => const MainInterface(),
      'searchPage': (context) => const SearchPage(),
      'login': (context) => const LoginScreen(),
      'newAccount': (context) => const CreateNewAccount()
    },
  ));
}

getCameras() {
  return cameras;
}

connexion(User user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("user", jsonEncode(user));
}

deconnexion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("user");
}
