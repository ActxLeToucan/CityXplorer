import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
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
  runApp(const App());
}

getCameras() {
  return cameras;
}
