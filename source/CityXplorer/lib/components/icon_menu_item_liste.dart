import 'dart:convert';

import 'package:cityxplorer/models/listes.dart';
import 'package:cityxplorer/models/post.dart';
import 'package:cityxplorer/models/user.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:cityxplorer/router/delegate.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:share_plus/share_plus.dart';

import '../conf.dart';

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
    var postId = widget.post.id;
    return PopupMenuButton(
        itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(
                    Icons.remove_red_eye,
                    size: 15.0,
                  ),
                  title: Text('Aperçu'),
                  onTap: () => routerDelegate.pushPage(
                      name: "/post",
                      arguments: {'id': widget.post.id.toString()}),
                ),
                value: 1,
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                    Icons.share,
                    size: 15.0,
                  ),
                  title: Text('Partager'),
                  onTap: () => Share.share(
                      "${Conf.domainServer}/post?id=${widget.post.id}"),
                ),
                value: 2,
              ),
              PopupMenuItem(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: ListTile(
                    tileColor: Colors.red,
                    leading: const Icon(
                      Icons.highlight_remove,
                      size: 30.0,
                    ),
                    title: const Text(
                      'Supprimer',
                      style: TextStyle(color: Colors.white),
                    ),
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
      title: const Text("Supprimer"),
      content: const Text(
          "Voulez-vous vraiment supprimer ce post ? Cette action est irréversible."),
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
    String url = Conf.domainServer +
        Conf.apiPath +
        "/postList?idPost=${widget.post.id}&idList=${widget.post.id.toInt()}&token=${widget.user.token}";

    try {
      var response = await http.delete(Uri.parse(url));
      print(widget.user.token);
      print(widget.post.titre);
      print(widget.post.description);
      print(widget.post.etat);
      print("Idpost");
      print(widget.post.id);
      print("idList");
      print(widget.list.id);
      print(widget.list.nomListe);
      print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);

      Fluttertoast.showToast(msg: data['message']);

      if (data["result"] == 1) {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }
  }
}
