import 'dart:convert';

import 'package:cityxplorer/models/listes.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:cityxplorer/router/delegate.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../conf.dart';

// menu de boutons lorsque l on clique sur les 3 points d une tuile d un post dans une liste du dashboard
class IconMenuListEdit extends StatefulWidget {
  final UserConnected user;
  final Listes list;
  const IconMenuListEdit({Key? key, required this.user, required this.list})
      : super(key: key);

  @override
  State<IconMenuListEdit> createState() => _IconMenuListEditState();
}

class _IconMenuListEditState extends State<IconMenuListEdit> {
  final routerDelegate = Get.find<MyRouterDelegate>();
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(
                    Icons.remove_red_eye,
                    size: 15.0,
                  ),
                  title: const Text('Modifier'),
                  onTap: () => routerDelegate.pushPage(
                      name: "/listEdit", arguments: {'list': widget.list}),
                ),
                value: 1,
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                    Icons.highlight_remove,
                    size: 30.0,
                  ),
                  title: Text(
                    'Supprimer',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                value: 2,
              )
            ],
        onSelected: (value) {
          switch (value) {
            case 2:
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
      onPressed: () => deleteList(context),
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Supprimer"),
      content: const Text(
          "Voulez-vous vraiment supprimer cette liste? Cette action est irréversible."),
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

  Future<void> deleteList(BuildContext context) async {
    String url = Conf.domainServer +
        Conf.apiPath +
        "/list?idList=${widget.list.id}&token=${widget.user.token}";
    try {
      var response = await http.delete(Uri.parse(url));
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
