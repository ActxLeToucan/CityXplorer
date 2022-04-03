import 'package:cityxplorer/models/post.dart';
import 'package:flutter/material.dart';
import 'package:cityxplorer/components/icon_menu_item_liste.dart';

//contenu de la page dashboard
class DashBoard extends StatelessWidget {
  final Map<dynamic, dynamic> lists;

  final Map<dynamic, dynamic> savedList;

  const DashBoard({Key? key, required this.lists, required this.savedList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> mesListes = [];
    lists.forEach((key, value) {
      List<Widget> items = [];
      for (final item in value) {
        items.add(_renderListTile(item));
      }
      mesListes.add(ExpansionTile(title: Text(key), children: items));
    });

    List<Widget> listeEnregistrees = [];
    lists.forEach((key, value) {
      List<Widget> items = [];
      for (final item in value) {
        items.add(_renderListTile(item));
      }
      mesListes.add(ExpansionTile(title: Text(key), children: items));
    });

    return Column(
      children: <Widget>[
        ExpansionTile(title: const Text("Mes listes"), children: mesListes),
        ExpansionTile(
            title: const Text("Les listes enregistrées"), children:listeEnregistrees),
      ],
    );
  }

  Widget _renderListTile(Post post) {
    return ListTile(
      title: Text(post.titre),
      trailing: IconMenu(),
    );
  }
}
