import 'package:cityxplorer/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../conf.dart';
import '../styles.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Styles.mainBackgroundColor),
          accountName: FutureBuilder<String>(
            future: _getName(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('${snapshot.data}');
              } else {
                return const Text("chargement...");
              }
            },
          ),
          accountEmail: FutureBuilder<String>(
            future: _getPseudo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('${snapshot.data}');
              } else {
                return const Text("chargement...");
              }
            },
          ),
          currentAccountPicture: _avatar(context)),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text("Se déconnecter"),
        onTap: () async {
          deconnexion();
          Navigator.of(context).pushNamedAndRemoveUntil(
              'login', (Route<dynamic> route) => false);
        },
      ),
    ]));
  }

  Widget _avatar(BuildContext context) {
    return GestureDetector(
        child: FutureBuilder<String>(
            future: _getAvatarUrl(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != "") {
                return CircleAvatar(
                  backgroundImage: const AssetImage('assets/avatar.png'),
                  foregroundImage: NetworkImage(snapshot.requireData),
                );
              } else {
                return const CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar.png'),
                );
              }
            }),
        onTap: () => Navigator.pushNamed(context, "userProfile"));
  }

  Future<String> _getPseudo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pseudo = prefs.getString("pseudo");
    return (pseudo != null ? "@$pseudo" : "invalid");
  }

  Future<String> _getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("user-name");
    return (name ?? "invalid");
  }

  Future<String> _getAvatarUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? photo = prefs.getString("avatar");
    if (photo == null || photo == "") {
      return "";
    } else {
      return "${Conf.bddDomainUrl}/img/avatar/$photo";
    }
  }
}
