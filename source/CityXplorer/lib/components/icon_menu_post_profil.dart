import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/post.dart';
import '../router/delegate.dart';

/// menu de boutons lorsque l on clique sur les 3 points dans le details d un post
class IconMenuPost extends StatefulWidget {
  final UserConneted user;
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

  @override
  Widget build(BuildContext context) {
    if (widget.user.isEmpty()) return Container();
    List<PopupMenuEntry<int>> options = [
      const PopupMenuItem(
        child: Text('Ajouter à une liste'),
        value: optionAddList,
      ),
    ];

    if (widget.user.niveauAcces >= 2) {
      options.add(const PopupMenuItem(
        child:
            Text('Changer la visibilité', style: TextStyle(color: Colors.blue)),
        value: optionDelete,
      ));
    }

    if (widget.user.pseudo == widget.post.userPseudo) {
      options.add(const PopupMenuItem(
        child: Text('Modifier'),
        value: optionEdit,
      ));
      options.add(const PopupMenuItem(
        child: Text('Supprimer', style: TextStyle(color: Colors.red)),
        value: optionDelete,
      ));
    }

    return PopupMenuButton(
        itemBuilder: (context) => options,
        onSelected: (value) {
          switch (value) {
            case optionAddList:
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
      onPressed: () {
        // supprimer le post de la bdd + retourner à la liste en faisant disparaitre le post
        //TODO
      },
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
}
