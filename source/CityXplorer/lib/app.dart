import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:cityxplorer/pages/main_interface.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainInterface(),
    );
  }
}
