import 'package:cityxplorer/models/listes.dart';
import 'package:cityxplorer/models/post.dart';
import 'package:cityxplorer/models/user.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:cityxplorer/components/icon_menu_item_liste.dart';

import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/menu.dart';
import '../models/user.dart';
import '../router/delegate.dart';
import '../styles.dart';
import '../vues/dashboard_card.dart';
import '../vues/home_card.dart';
const FooterHeight=100.0;
//contenu de la page dashboard
class DashBoard extends StatefulWidget {
  const DashBoard({Key? key})
      : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final routerDelegate = Get.find<MyRouterDelegate>();
  bool _initialized = false;
  List<Listes> _createdLists=[];
  List<Listes>_savedLists=[];
  Map<dynamic,dynamic> _mapCreatedList={};
  Map<dynamic,dynamic> _mapSavedList={};
  User _user = User.empty();

  @override
  void initState() {
    super.initState();
    _load();
  }



  @override
  Widget build(BuildContext context) {
    List<Widget> mesListes = []; //Listes crées
    List<Widget> listeEnregistrees = []; //Listes enregistrées

   _mapCreatedList.forEach((key, value) {
      List<Widget> items = [];
      for (final item in value) {
        items.add(_renderListTile(item));
      }
      mesListes.add(ExpansionTile(title: Text(key), children: items));
    });

    _mapSavedList.forEach((key, value) {
      List<Widget> items = [];
      for (final item in value) {
        items.add(_renderListTile(item));
      }
      listeEnregistrees.add(ExpansionTile(title: Text(key), children: items));
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
  //Map nomListe-List<post>
  Future<Map> _getPostListCreatedForDashboard() async{
    var lists = {};
    print(_createdLists);
    for (var listeToTurn in _createdLists) {
      print("Id list");
      print(listeToTurn.id);
      lists[listeToTurn.nomListe]= listeToTurn.getPostsOfList(_user);
    }
    print("Lists Created : ");
    print(lists);
    return lists;
  }
  //Map nomListe-List<post>
  Future<Map> _getPostListLikedForDashboard() async{
    var listsSaved = {};
    for (var listeToTurn in _savedLists) {
      listsSaved[listeToTurn.nomListe]= listeToTurn.getPostsOfList(_user);
    }
    print("Lists saved : ");
    print(listsSaved);
    return listsSaved;
  }

  Future<void> _load() async {
    setState(() {
      _initialized = false;
    });
    UserConneted user = await getUser();

    List<Listes> pc = await user.getListsCreated();
    List<Listes> pl = await user.getListsLiked();
    Map<dynamic, dynamic> mpc = await _getPostListCreatedForDashboard();
    Map<dynamic, dynamic> mpl =await _getPostListLikedForDashboard();
    setState(() {
      _user = user;
      _initialized = true;
      _createdLists=pc;
      _savedLists=pl;
      _mapCreatedList=mpc;
      _mapSavedList=mpl;
    });


      setState(() {
        _initialized = true;
      });
  }

}
