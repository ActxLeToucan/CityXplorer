import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:cityxplorer/models/user_connected.dart';
import 'package:cityxplorer/router/delegate.dart';
import 'package:cityxplorer/router/information_parser.dart';
import 'package:cityxplorer/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import 'my_http_overrides.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final routerDelegate = Get.put(MyRouterDelegate());

  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    routerDelegate.pushPage(name: '/');

    if (!kIsWeb) initialize();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initialize() async {
    try {
      // Get the link that launched the app
      final initialUri = await getInitialUri();

      if (initialUri != null) {
        routerDelegate.parseRoute(initialUri);
      }
    } on FormatException catch (error) {
      error.printError();
    }

    // Attach a listener to the uri_links stream
    _linkSubscription = uriLinkStream.listen((uri) {
      if (!mounted) return;
      routerDelegate.parseRoute(uri!);
    }, onError: (error) => error.printError());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CityXplorer',
      theme: ThemeData(
          colorScheme: const ColorScheme.light(primary: Styles.mainColor)),
      routerDelegate: routerDelegate,
      routeInformationParser: const MyRouteInformationParser(),
    );
  }
}

getCameras() {
  return cameras;
}

Future<void> connexion(UserConneted user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("user", jsonEncode(user));
}

Future<void> deconnexion() async {
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
