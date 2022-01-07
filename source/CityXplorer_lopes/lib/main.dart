import 'package:cityxplorer_lopes/add_post_card.dart';
import 'package:cityxplorer_lopes/dashboard_card.dart';
import 'package:cityxplorer_lopes/profil_card.dart';
import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'home_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityXplorerV1',
      theme: ThemeData(
      ),
      home: const MyHomePage(title: 'Flutter home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    Home(),
    //AddPost(),
    UserProfil(),
    DashBoard(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Column(
          children: [
            AppBarPerso(
              title: '',
              authorName: "",
              imageProvider: AssetImage('assets/alexis.jpg'),
            ),
            pages[_selectedIndex],
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.plus_one),
              label: 'Ajouter un poste',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.speed),
              label: 'Dashboard',
            ),
          ],
        ),
      );
  }
}
