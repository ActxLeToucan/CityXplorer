import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../conf.dart';
import '../styles.dart';

class Menu extends StatelessWidget {
  final ImageProvider avatar;

  const Menu({Key? key, required this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Styles.mainBackgroundColor),
        accountName: FutureBuilder<String>(
          future: _getPseudo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('${snapshot.data}');
            } else {
              return const Text("chargement...");
            }
          },
        ),
        accountEmail: FutureBuilder<String>(
          future: _getEmail(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('${snapshot.data}');
            } else {
              return const Text("chargement...");
            }
          },
        ),
        currentAccountPicture: GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              foregroundImage: avatar,
            ),
            onTap: () => Navigator.pushNamed(context, "userProfile")),
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text("Se déconnecter"),
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove(Conf.stayLogin);
          prefs.remove("email");
          Navigator.of(context).pushNamedAndRemoveUntil(
              'login', (Route<dynamic> route) => false);
        },
      ),
    ]));
  }

  Future<String> _getPseudo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pseudo = prefs.getString(Conf.stayLogin);
    return (pseudo ?? "invalid");
  }

  Future<String> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    return (email ?? "invalid");
  }
}
