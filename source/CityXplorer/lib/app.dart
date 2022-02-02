import 'package:cityxplorer/pages/pages.dart';
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
