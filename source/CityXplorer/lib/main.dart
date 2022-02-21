import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:cityxplorer/pages/create_account.dart';
import 'package:cityxplorer/pages/login_screen.dart';
import 'package:cityxplorer/pages/main_interface.dart';
import 'package:cityxplorer/pages/search_page.dart';
import 'package:cityxplorer/styles.dart';
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

  UserConneted user = await getUser();
  runApp(MaterialApp(
    title: 'CityXplorer',
    theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Styles.mainColor)),
    home: (user.isEmpty() ? const LoginScreen() : const MainInterface()),
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

connexion(UserConneted user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("user", jsonEncode(user));
}

deconnexion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("user");
}

Future<UserConneted> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userString = prefs.getString('user');
  UserConneted user = UserConneted.empty();
  if (userString != null) {
    user = UserConneted.fromJson(jsonDecode(userString));
  }
  return user;
}

Future<bool> isCurrentUser(String pseudo) async {
  UserConneted user = await getUser();
  return user.pseudo.compareTo(pseudo) == 0;
}
