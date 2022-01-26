import 'package:cityxplorer/components/appbar_default.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/vues/take_photo_screen.dart';
import 'package:flutter/material.dart';

import '../components/menu.dart';
import '../vues/dashboard_card.dart';
import '../vues/home_card.dart';

class MainInterface extends StatefulWidget {
  const MainInterface({Key? key}) : super(key: key);

  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    Home(),
    TakePictureScreen(camera: getCameras()[0]),
    const DashBoard(
      lists: {
        "Ma liste 1": ["item 1", "item 2", "item 3"],
        "Ma liste 2": ["item 4"]
      },
      savedItems: [
        "item enregistré 1",
        "item enregistré 2",
        "item enregistré 3"
      ],
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(context),
      body: SingleChildScrollView(
        child: Column(children: [
          pages[_selectedIndex],
        ]),
      ),
      drawer: Menu(
          nom: "Alexis Lopes Vaz",
          email: "tiplou@gmail.com",
          avatar: AssetImage('assets/alexis.jpg')),
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
