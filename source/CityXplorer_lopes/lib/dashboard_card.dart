import 'package:flutter/material.dart';
import 'app_bar.dart';

//contenu de la page dashboard
class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 470,
          color: Colors.transparent,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children:  <Widget>[
                ExpansionTile(
                  title: Text(
                    "Mes listes",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  children: <Widget>[
                    ExpansionTile(
                      title: Text(
                        "Les places de Nancy",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      children: <Widget>[
                        _renderListTile('Plan Stanislas'),
                        _renderListTile('Place Carnot'),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        "Les bars branchés de Laxou",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      children: <Widget>[
                        _renderListTile('Bar 1'),
                      ],
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Mes postes enregistrés",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  children: <Widget>[
                    _renderListTile('Statue Blandan'),
                  ],
                ),
              ],
            ),
        ),
        ),
      ],
    );
  }
  Widget _renderListTile(String s) {
    return ListTile(
      title: Text(s),
      trailing :  Icon(Icons.more_vert),
    );
  }
}