import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../router/delegate.dart';

// menu de boutons lorsque l on clique sur les 3 points dans le details d un post dans le profil
class IconMenuPost extends StatefulWidget {
  const IconMenuPost({Key? key}) : super(key: key);

  @override
  State<IconMenuPost> createState() => _IconMenuPostState();
}

class _IconMenuPostState extends State<IconMenuPost> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Modifier'),
                ),
                value: 0,
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Supprimer',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                value: 1,
              ),
            ],
        onSelected: (value) {
          if (value == 0) {
            print("MODIFIER.");
          } else if (value == 1) {
            alertDialogDelete(context);
          }
        });
  }

  alertDialogDelete(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed: () => routerDelegate.popRoute(),
    );
    Widget continueButton = TextButton(
      child: const Text(
        "Supprimer",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      onPressed: () {
        // supprimer le post de la bdd + retourner à la liste en faisant disparaitre le post
        //TODO
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Supprimer"),
      content: Text("Etes vous sûr de vouloir supprimer ce post ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
