import 'package:flutter/material.dart';
import 'package:cityxplorer/components/icon_menu_item_liste.dart';

//contenu de la page dashboard
class DashBoard extends StatelessWidget {
  final Map<String, List<String>> lists;

  final List<String> savedItems;

  const DashBoard({Key? key, required this.lists, required this.savedItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> mesListes = [];
    lists.forEach((key, value) {
      List<Widget> items = [];
      for (final item in value) {
        items.add(_renderListTile(item.toString()));
      }
      mesListes.add(ExpansionTile(title: Text(key), children: items));
    });

    List<Widget> itemsEnregistres = [];
    for (final item in savedItems) {
      itemsEnregistres.add(_renderListTile(item.toString()));
    }

    return Column(
      children: <Widget>[
        ExpansionTile(title: const Text("Mes listes"), children: mesListes),
        ExpansionTile(
            title: const Text("Items enregistrés"), children: itemsEnregistres),
      ],
    );
  }

  Widget _renderListTile(String s) {
    return ListTile(
      title: Text(s),
      trailing: IconMenu(),
    );
  }
}
