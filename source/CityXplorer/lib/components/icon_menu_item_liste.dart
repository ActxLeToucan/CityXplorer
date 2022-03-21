import 'package:flutter/material.dart';

// menu de boutons lorsque l on clique sur les 3 points d une tuile d un post dans une liste du dashboard
class IconMenu extends StatelessWidget {
  const IconMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.remove_red_eye),
                  title: Text('Aperçu'),
                ),
                value: 1,
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Ajouter à une liste'),
                ),
                value: 2,
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Partager'),
                ),
                value: 3,
              ),
            ]);
  }
}
