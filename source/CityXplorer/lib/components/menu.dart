import 'dart:convert';

import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../conf.dart';
import '../models/user.dart';
import '../pages/user_profile.dart';
import '../styles.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: Styles.mainColor),
          accountName: FutureBuilder<User>(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.requireData.name);
              } else {
                return const Text("chargement...");
              }
            },
          ),
          accountEmail: FutureBuilder<UserConneted>(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('@${snapshot.requireData.pseudo}');
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
        onTap: () async {
          UserConneted user = await getUser();
          if (!user.isEmpty()) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserProfile(user: user)));
          }
        });
  }

  Future<String> _getAvatarUrl() async {
    UserConneted user = await getUser();
    String photo = user.avatar;
    if (photo == "") {
      return "";
    } else {
      return "${Conf.bddDomainUrl}/img/avatar/$photo";
    }
  }
}
