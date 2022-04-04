import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/vues/take_photo_screen.dart';
import 'package:cityxplorer/vues/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
            child:DashBoard(),),
        _renderFooter(context)
      ],)
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
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo_rounded),
            label: 'Créer un post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Tableau de bord',
          ),
        ],
      )
          : null,
    );
  }
  Widget _renderFooter(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(color:Colors.white.withOpacity(0.5)),
          height: FooterHeight,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 30.0),
            child:_renderFooterAddListButton(),
          ),
        )
      ],
    );
  }
  Widget _renderFooterAddListButton() {
    return FlatButton(
      color: Styles.mainColor,
      textColor: Styles.loginTextColor,
      onPressed: _handleAddListPress,
      child: Text('Ajouter une liste'.toUpperCase(), style: Styles.textCTAButton),
    );
  }
  void _handleAddListPress() async{
    routerDelegate.pushPage(name: '/new_list');
  }
}
