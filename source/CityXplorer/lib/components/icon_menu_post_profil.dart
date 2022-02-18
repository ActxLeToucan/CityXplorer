
import 'package:flutter/material.dart';

// menu de boutons lorsque l on clique sur les 3 points dans le details d un post dans le profil
class IconMenuPost extends StatelessWidget {

  const IconMenuPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Modifier'),
              ),
              value: 1,
            ),
            const PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Supprimer',
                  style: TextStyle(
                    color: Colors.red,
                ),),
              ),
              value: 2,
            ),
          ]
      );
    }
  }

