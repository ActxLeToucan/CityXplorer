import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/vues/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/input_field.dart';
import '../components/menu.dart';
import '../models/user.dart';
import '../router/delegate.dart';
import '../styles.dart';
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
      const Camera(),
      Stack(
        children: [
          const SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: DashBoard(),
          ),
          _renderFooter(context)
        ],
      )
    ];

    return Scaffold(
      backgroundColor:
          Styles.darkMode ? Styles.darkBackground : Styles.lightBackground,
      appBar: defaultAppBar(context),
      body: pages[_selectedIndex],
      drawer: const Menu(),
      bottomNavigationBar: _initialized && !_user.isEmpty()
          ? BottomNavigationBar(
              backgroundColor:
                  Styles.darkMode ? Styles.darkElement : Styles.lightElement,
              selectedItemColor:
                  Theme.of(context).textSelectionTheme.selectionColor,
              unselectedItemColor:
                  Styles.darkMode ? Styles.darkTextColor : Colors.black54,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home,
                      color:
                          Styles.darkMode ? Styles.darkTextColor : Colors.grey),
                  label: 'Accueil',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_a_photo_rounded,
                      color:
                          Styles.darkMode ? Styles.darkTextColor : Colors.grey),
                  label: 'Créer un post',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.speed,
                      color:
                          Styles.darkMode ? Styles.darkTextColor : Colors.grey),
                  label: 'Tableau de bord',
                ),
              ],
            )
          : null,
    );
  }

  Widget _renderFooter(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
              color: (Styles.darkMode
                      ? Styles.darkBackground
                      : Styles.lightBackground)
                  .withOpacity(0.5)),
          height: footerHeight,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: _renderFooterAddListButton(),
          ),
        )
      ],
    );
  }

  Widget _renderFooterAddListButton() {
    return Button(
      type: ButtonType.big,
      text: 'Ajouter une liste',
      onPressed: _handleAddListPress,
    );
  }

  void _handleAddListPress() async {
    routerDelegate.pushPage(name: '/new_list');
  }
}
