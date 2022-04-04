import 'package:cityxplorer/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../conf.dart';
import '../main.dart';
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
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView(padding: EdgeInsets.zero, shrinkWrap: true, children: [
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
          (_user.niveauAcces >= 2)
              ? ListTile(
                  leading: const Icon(
                    Icons.verified_user,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    "Valider des posts",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () => routerDelegate.pushPage(name: '/validationPost'),
                )
              : Container(),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Crédits"),
            onTap: () async {
              routerDelegate.pushPage(name: '/credit');
            },
          ),
        ]),
        _user.niveauAcces >= 2
            ? IconButton(
                icon: const Icon(Icons.verified_user),
                color: Colors.blue,
                iconSize: 40,
                onPressed: () {
                  Fluttertoast.showToast(msg: "Vous êtes administrateur💪.");
                },
              )
            : Container(),
      ],
    ));
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
