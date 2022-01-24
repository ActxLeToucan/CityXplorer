import 'package:flutter/material.dart';

//contenu de la page dashboard
class DashBoard extends StatelessWidget {
  final Map<String, List<String>> lists;

  final List<String> savedItems;

  const DashBoard({required this.lists, required this.savedItems});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Text("Mes listes"),
          children: <Widget>[
            ExpansionTile(
              title: Text("Ma liste 1"),
              children: <Widget>[
                _renderListTile("Item 1"),
                _renderListTile("Item 2"),
                _renderListTile("Item 3"),
                _renderListTile("Item 4"),
              ],
            ),
            ExpansionTile(
              title: Text("Ma liste 2"),
              children: <Widget>[
                _renderListTile("Item 1"),
                _renderListTile("Item 2"),
                _renderListTile("Item 3"),
                _renderListTile("Item 4"),
              ],
            ),
          ],
        ),
        ExpansionTile(
          title: Text("Items enregistrés"),
          children: <Widget>[
            for (final item in this.savedItems)
              _renderListTile(item.toString()),
          ],
        ),
      ],
    );
  }

  Widget _renderListTile(String s) {
    return ListTile(
      title: Text(s),
      trailing: Icon(Icons.more_vert),
    );
  }
}
