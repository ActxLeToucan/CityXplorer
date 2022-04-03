import 'package:cityxplorer/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';

import '../conf.dart';
import '../models/user.dart';
import '../router/delegate.dart';
import '../styles.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  bool _initialized = false;
  User _user = User.empty();

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: Styles.mainColor),
          accountName: Text(!_initialized
              ? "chargement..."
              : _user.name == ""
                  ? "Utilisateur non connecté"
                  : _user.name),
          accountEmail: Text(!_initialized
              ? "chargement..."
              : _user.pseudo == ""
                  ? ""
                  : "@${_user.pseudo}"),
          currentAccountPicture: _avatar(context)),
      ListTile(
        leading: Icon(_user.isEmpty() ? Icons.login : Icons.logout),
        title: Text(_user.isEmpty() ? "Se connecter" : "Se déconnecter"),
        onTap: () async {
          if (!_user.isEmpty()) {
            deconnexion();
          }
          routerDelegate.pushPageAndClear(name: '/login');
        },
      ),
    ]));
  }

  Widget _avatar(BuildContext context) {
    String avatarUrl = _getAvatarUrl();
    return GestureDetector(
        child: avatarUrl != ""
            ? CircleAvatar(
                backgroundColor: Styles.mainColor,
                foregroundImage: NetworkImage(avatarUrl),
              )
            : (_initialized
                ? const CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.png'),
                  )
                : const CircleAvatar(
                    child: CircularProgressIndicator(),
                    backgroundColor: Colors.white,
                  )),
        onTap: () {
          if (!_user.isEmpty()) {
            _user.pushPage();
          }
        });
  }

  String _getAvatarUrl() {
    String photo = _user.avatar;
    if (photo == "") {
      return "";
    } else {
      return "${Conf.domainServer}/img/avatar/$photo";
    }
  }
}
