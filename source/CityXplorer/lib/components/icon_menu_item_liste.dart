import 'dart:convert';

import 'package:cityxplorer/models/listes.dart';
import 'package:cityxplorer/models/post.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:cityxplorer/router/delegate.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:share_plus/share_plus.dart';

import '../conf.dart';
import '../styles.dart';

// menu de boutons lorsque l on clique sur les 3 points d une tuile d un post dans une liste du dashboard
class IconMenu extends StatefulWidget {
  final Post post;
  final UserConnected user;
  final Listes list;
  const IconMenu(
      {Key? key, required this.post, required this.user, required this.list})
      : super(key: key);

  @override
  State<IconMenu> createState() => _IconMenuState();
}

class _IconMenuState extends State<IconMenu> {
  final routerDelegate = Get.find<MyRouterDelegate>();
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        color: (Styles.darkMode ? Styles.darkElement : Styles.lightElement),
        icon: Icon(
          Icons.more_vert,
          color: (Styles.darkMode ? Styles.darkTextColor : Colors.black54),
        ),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  textColor: (Styles.darkMode
                      ? Styles.darkTextColor
                      : Styles.lightTextColor),
                  title: const Text('Aperçu'),
                  onTap: () => routerDelegate.pushPage(
                      name: "/post",
                      arguments: {'id': widget.post.id.toString()}),
                ),
                value: 1,
              ),
              PopupMenuItem(
                child: ListTile(
                  textColor: (Styles.darkMode
                      ? Styles.darkTextColor
                      : Styles.lightTextColor),
                  title: const Text('Partager'),
                  onTap: () => Share.share(
                      "${Conf.domainServer}/post?id=${widget.post.id}"),
                ),
                value: 2,
              ),
              const PopupMenuItem(
                child: ListTile(
                  title: Text(
                    'Supprimer',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                value: 3,
              )
            ],
        onSelected: (value) {
          switch (value) {
            case 3:
              alertDelete(context);
              break;
          }
        });
  }

  void alertDelete(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Annuler"),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
      onPressed: () => deletePostList(context),
    );

    AlertDialog alert = AlertDialog(
      backgroundColor:
          (Styles.darkMode ? Styles.darkElement : Styles.lightElement),
      title: Text(
        "Supprimer",
        style: TextStyle(
          color:
              (Styles.darkMode ? Styles.darkTextColor : Styles.lightTextColor),
        ),
      ),
      content: Text(
          "Voulez-vous vraiment supprimer ce post ? Cette action est irréversible.",
          style: TextStyle(
            color: (Styles.darkMode
                ? Styles.darkTextColor
                : Styles.lightTextColor),
          )),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> deletePostList(BuildContext context) async {
    String url = Conf.domainApi +
        "/postList?idPost=${widget.post.id}&idList=${widget.list.id}&token=${widget.user.token}";
    try {
      var response = await http.delete(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);

      Fluttertoast.showToast(
          backgroundColor: Styles.mainColor, msg: data['message']);

      if (data["result"] == 1) {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          backgroundColor: Styles.darkMode ? Styles.darkRed : Colors.redAccent,
          msg: "Impossible d'accéder à la base de données.");
    }
  }
}
