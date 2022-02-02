import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:cityxplorer/pages/create-new-account.dart';
import 'package:cityxplorer/pages/display_picture_screen.dart';
import 'package:cityxplorer/pages/login-screen.dart';
import 'package:cityxplorer/pages/main_interface.dart';
import 'package:cityxplorer/pages/search_page.dart';
import 'package:cityxplorer/pages/profil_card.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityXplorer',
      initialRoute: '/',
      routes: {
        '/': (context) => MainInterface(),
        'searchPage': (context) => SearchPage(),
        'userProfile': (context) => UserProfile(),
        'login': (context) => LoginScreen(),
        'newAccount': (context) => CreateNewAccount()
      },
    );
  }
}
