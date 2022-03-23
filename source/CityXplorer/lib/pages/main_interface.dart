import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/vues/take_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/menu.dart';
import '../models/user.dart';
import '../router/delegate.dart';
import '../vues/dashboard_card.dart';
import '../vues/home_card.dart';

class MainInterface extends StatefulWidget {
  const MainInterface({Key? key}) : super(key: key);

  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  int _selectedIndex = 0;

  bool _initialized = false;
  User _user = User.empty();

  @override
  initState() {
    super.initState();
    getUser().then((user) {
      setState(() {
        _user = user;
        _initialized = true;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _initialized = true;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[
      SingleChildScrollView(
          child: Home(initialized: _initialized, user: _user)),
      getCameras().length > 0
          ? TakePictureScreen(camera: getCameras()[0])
          : const Text("Erreur camera"),
      const SingleChildScrollView(
          child: DashBoard(
        lists: {
          "Ma liste 1": ["item 1", "item 2", "item 3"],
          "Ma liste 2": ["item 4"],
          "Ma liste 3": ["item 5", "item 6"],
        },
        savedItems: [
          "item enregistré 1",
          "item enregistré 2",
          "item enregistré 3"
        ],
      )),
    ];

    return Scaffold(
      appBar: defaultAppBar(context),
      body: pages[_selectedIndex],
      drawer: const Menu(),
      bottomNavigationBar: _initialized && !_user.isEmpty()
          ? BottomNavigationBar(
              selectedItemColor:
                  Theme.of(context).textSelectionTheme.selectionColor,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_a_photo_rounded),
                  label: 'Créer un post',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.speed),
                  label: 'Dashboard',
                ),
              ],
            )
          : null,
    );
  }
}
