import 'package:cityxplorer/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        backgroundColor:
            Styles.darkMode ? Styles.darkElement : Styles.lightElement,
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
                leading: Icon(
                  _user.isEmpty() ? Icons.login : Icons.logout,
                  color: Styles.darkMode ? Styles.darkTextColor : Colors.grey,
                ),
                title:
                    Text(_user.isEmpty() ? "Se connecter" : "Se déconnecter"),
                textColor:
                    Styles.darkMode ? Styles.darkTextColor : Colors.black87,
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
                      onTap: () =>
                          routerDelegate.pushPage(name: '/validationPost'),
                    )
                  : Container(),
              ListTile(
                leading: Icon(Icons.people,
                    color:
                        Styles.darkMode ? Styles.darkTextColor : Colors.grey),
                title: const Text("Crédits"),
                textColor:
                    Styles.darkMode ? Styles.darkTextColor : Colors.black87,
                onTap: () async {
                  routerDelegate.pushPage(name: '/credit');
                },
              ),
              ListTile(
                leading: Icon(
                    Styles.darkMode ? Icons.nightlight_round : Icons.wb_sunny,
                    color:
                        Styles.darkMode ? Styles.darkTextColor : Colors.grey),
                title: const Text("Changer de thème"),
                textColor:
                    Styles.darkMode ? Styles.darkTextColor : Colors.black87,
                onTap: () async {
                  Styles.darkMode = !Styles.darkMode;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool("darkTheme", Styles.darkMode);
                  Phoenix.rebirth(context);
                },
              ),
            ]),
            _user.niveauAcces >= 2
                ? IconButton(
                    icon: const Icon(Icons.verified_user),
                    color: Colors.blue,
                    iconSize: 40,
                    onPressed: () {
                      Fluttertoast.showToast(
                          backgroundColor: Styles.mainColor,
                          msg: "Vous êtes administrateur💪.");
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
                : CircleAvatar(
                    child: const CircularProgressIndicator(),
                    backgroundColor: Styles.darkMode
                        ? Styles.darkBackground
                        : Styles.lightBackground,
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
      return "${Conf.domainServer}/img/avatars/$photo";
    }
  }
}
