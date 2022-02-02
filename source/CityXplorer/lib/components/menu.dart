import 'package:flutter/material.dart';

import '../styles.dart';

class Menu extends StatelessWidget {
  final email;
  final ImageProvider avatar;
  final nom;

  const Menu(
      {Key? key,
      required String this.nom,
      required String this.email,
      required this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Styles.mainBackgroundColor),
        accountName: Text(this.nom),
        accountEmail: Text(this.email),
        currentAccountPicture: GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              foregroundImage: this.avatar,
            ),
            onTap: () => Navigator.pushNamed(context, "userProfile")),
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text("Settings"),
        onTap: () {
          Navigator.pushNamed(context, "login");
        },
      ),
    ]));
  }
}
