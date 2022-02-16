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
  var token = prefs.getString("token");

  runApp(MaterialApp(
    title: 'CityXplorer',
    home: (token == null ? const LoginScreen() : const MainInterface()),
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

connexion(Map<String, dynamic> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("token", data['user']['token']);
  prefs.setString("pseudo", data['user']['pseudo']);
  prefs.setString("user-name", data['user']['name']);
  prefs.setString("avatar", data['user']['avatar']);
}

deconnexion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("token");
  prefs.remove("pseudo");
  prefs.remove("user-name");
  prefs.remove("avatar");
}
