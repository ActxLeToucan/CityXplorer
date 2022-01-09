import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pages/screens.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

 /* @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Secure Login",
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityXplorer',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        'CreateNewAccount': (context) => CreateNewAccount(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
