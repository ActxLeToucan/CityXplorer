import 'dart:convert';

import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../models/post.dart';
import '../router/delegate.dart';
import '../styles.dart';

/// menu de boutons lorsque l on clique sur les 3 points dans le details d un post
class IconMenuPost extends StatefulWidget {
  final UserConnected user;
  final Post post;
  const IconMenuPost({Key? key, required this.user, required this.post})
      : super(key: key);

  @override
  State<IconMenuPost> createState() => _IconMenuPostState();
}

class _IconMenuPostState extends State<IconMenuPost> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  static const int optionAddList = 0;
  static const int optionEdit = 1;
  static const int optionDelete = 2;
  static const int optionVisibility = 3;
  static const int optionBlockedToPending = 4;

  @override
  Widget build(BuildContext context) {
    if (widget.user.isEmpty()) return Container();
    List<PopupMenuEntry<int>> options = [
      PopupMenuItem(
        child: Text('Ajouter à une liste',
            style: TextStyle(
                color: Styles.darkMode
                    ? Styles.darkTextColor
                    : Styles.lightTextColor)),
        value: optionAddList,
      ),
    ];

    if (widget.user.niveauAcces >= 2) {
      options.add(const PopupMenuItem(
        child:
            Text('Changer la visibilité', style: TextStyle(color: Colors.blue)),
        value: optionVisibility,
      ));
    }

    if (widget.user.pseudo == widget.post.userPseudo) {
      if (widget.post.etat == Post.postEtatBloque) {
        options.add(const PopupMenuItem(
          child: Text('Redemander validation',
              style: TextStyle(color: Colors.orange)),
          value: optionBlockedToPending,
        ));
      }
      options.add(PopupMenuItem(
        child: Text('Modifier',
            style: TextStyle(
                color: Styles.darkMode
                    ? Styles.darkTextColor
                    : Styles.lightTextColor)),
        value: optionEdit,
      ));
      options.add(const PopupMenuItem(
        child: Text('Supprimer', style: TextStyle(color: Colors.red)),
        value: optionDelete,
      ));
    }

    return PopupMenuButton(
        color: (Styles.darkMode ? Styles.darkElement : Styles.lightElement),
        icon: Icon(
          Icons.more_vert,
          color: (Styles.darkMode ? Styles.darkTextColor : Colors.black54),
        ),
        itemBuilder: (context) => options,
        onSelected: (value) {
          switch (value) {
            case optionAddList:
              routerDelegate.pushPage(
                  name: '/post/list',
                  arguments: {'id': widget.post.id.toString()});
              break;
            case optionEdit:
              routerDelegate.pushPage(
                  name: '/post/edit',
                  arguments: {'id': widget.post.id.toString()});
              break;
            case optionDelete:
              alertDelete(context);
              break;
            case optionVisibility:
              alertVisibility(context);
              break;
            case optionBlockedToPending:
              blockedToPending();
              break;
          }
        });
  }

  void alertDelete(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Annuler"),
      onPressed: () => routerDelegate.popRoute(),
    );
    Widget continueButton = TextButton(
      child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
      onPressed: deletePost,
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

  void alertVisibility(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Annuler"),
      onPressed: () => Navigator.pop(context),
    );
    Widget blockButton = TextButton(
      child: const Text("Bloquer", style: TextStyle(color: Colors.red)),
      onPressed: () => changeState("-1"),
    );
    Widget validateButton = TextButton(
      child: const Text("Valider", style: TextStyle(color: Colors.green)),
      onPressed: () => changeState("1"),
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Visibilité du post"),
      content: const Text("Que voulez-vous faire ?"),
      actions: [
        cancelButton,
        blockButton,
        validateButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> deletePost() async {
    String url = Conf.domainApi +
        "/post?id=${widget.post.id}&token=${widget.user.token}";

    try {
      var response = await http.delete(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);

      Fluttertoast.showToast(
          backgroundColor: Styles.mainColor, msg: data['message']);

      if (data["result"] == 1) {
        routerDelegate.popRoute();
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          backgroundColor: Styles.darkMode ? Styles.darkRed : Colors.redAccent,
          msg: "Impossible d'accéder à la base de données.");
    }
  }

  /// methode qui envoie une requete patch avec en parametre l etat final du post
  /// affiche un toast pour l utilisateur l informant du resultat
  Future<void> changeState(String newState) async {
    String url = Conf.domainApi + "/post";
    Map<String, dynamic> body = {
      "token": widget.user.token,
      "id": widget.post.id,
      "etat": newState.toString(),
    };
    try {
      var response = await http.patch(Uri.parse(url),
          body: json.encode(body),
          headers: {'content-type': 'application/json'});
      final Map<String, dynamic> data = json.decode(response.body);
      Fluttertoast.showToast(
          backgroundColor: Styles.mainColor, msg: data['message']);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          backgroundColor: Styles.darkMode ? Styles.darkRed : Colors.redAccent,
          msg: "Impossible d'accéder à la base de données.");
    }
    Navigator.pop(context);
  }

  Future<void> blockedToPending() async {
    String url = Conf.domainApi + "/post_pending";
    Map<String, dynamic> body = {
      "token": widget.user.token,
      "id": widget.post.id
    };
    try {
      var response = await http.patch(Uri.parse(url),
          body: json.encode(body),
          headers: {'content-type': 'application/json'});
      final Map<String, dynamic> data = json.decode(response.body);
      Fluttertoast.showToast(
          backgroundColor: Styles.mainColor, msg: data['message']);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          backgroundColor: Styles.darkMode ? Styles.darkRed : Colors.redAccent,
          msg: "Impossible d'accéder à la base de données.");
    }
  }
}
