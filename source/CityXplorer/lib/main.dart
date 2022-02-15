import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'conf.dart';
import 'my_http_overrides.dart';
import 'pages/pages.dart';

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
  var pseudo = prefs.getString(Conf.stayLogin);

  runApp(MaterialApp(
    title: 'CityXplorer',
    home: (pseudo == null ? const LoginScreen() : const MainInterface()),
    routes: {
      'main': (context) => const MainInterface(),
      'searchPage': (context) => const SearchPage(),
      'userProfile': (context) => const UserProfile(),
      'login': (context) => const LoginScreen(),
      'newAccount': (context) => const CreateNewAccount()
    },
  ));
}

getCameras() {
  return cameras;
}
