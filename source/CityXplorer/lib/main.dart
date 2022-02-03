import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    home: (pseudo == null ? LoginScreen() : MainInterface()),
    routes: {
      'main': (context) => MainInterface(),
      'searchPage': (context) => SearchPage(),
      'userProfile': (context) => UserProfile(),
      'login': (context) => LoginScreen(),
      'newAccount': (context) => CreateNewAccount()
    },
  ));
}

getCameras() {
  return cameras;
}
