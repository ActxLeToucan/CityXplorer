import 'package:cityxplorer/models/listes.dart';
import 'package:cityxplorer/models/post.dart';
import 'package:cityxplorer/models/user.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:cityxplorer/components/icon_menu_item_liste.dart';

import 'package:cityxplorer/main.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../router/delegate.dart';

const footerHeight = 100.0;

//contenu de la page dashboard
class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final routerDelegate = Get.find<MyRouterDelegate>();
  bool _initialized = false;
  List<Listes> _createdLists = [];
  List<Listes> _savedLists = [];
  Map<dynamic, dynamic> _mapCreatedList = {};
  Map<dynamic, dynamic> _mapSavedList = {};
  UserConnected _user = UserConnected.empty();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      List<Widget> mesListes = []; //Listes crées
      List<Widget> listeEnregistrees = []; //Listes enregistrées
      _mapCreatedList.forEach((key, value) {
        List<Widget> items = [];
        for (final item in value) {
          final list =
              _createdLists.singleWhere((element) => element.nomListe == key);
          items.add(_renderListTile(item, list));
        }
        mesListes.add(ExpansionTile(title: Text(key), children: items));
      });
      _mapSavedList.forEach((key, value) {
        List<Widget> items = [];
        for (final item in value) {
          final list =
              _savedLists.singleWhere((element) => element.nomListe == key);
          items.add(_renderListTile(item, list));
        }
        listeEnregistrees.add(ExpansionTile(title: Text(key), children: items));
      });

      return RefreshIndicator(
          onRefresh: _load,
          child: Column(
            children: <Widget>[
              ExpansionTile(
                  title: const Text("Mes listes"), children: mesListes),
              ExpansionTile(
                  title: const Text("Les listes enregistrées"),
                  children: listeEnregistrees),
              _tqtCestDeLaTriche(context)
            ],
          ));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
  /*
  * body: RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
  * */

  Widget _renderListTile(Post post, Listes list) {
    return ListTile(
      title: Text(post.titre),
      trailing: IconMenu(
        post: post,
        user: _user,
        list: list,
      ),
    );
  }

  //Map nomListe-List<post>
  Future<Map> _getPostListCreatedForDashboard() async {
    var lists = {};
    for (var listeToTurn in _createdLists) {
      List<Post> val = await listeToTurn.getPostsOfList();
      lists[listeToTurn.nomListe] = val;
    }
    return lists;
  }

  //Map nomListe-List<post>
  Future<Map> _getPostListLikedForDashboard() async {
    var listsSaved = {};
    for (var listeToTurn in _savedLists) {
      List<Post> val = await listeToTurn.getPostsOfList();
      listsSaved[listeToTurn.nomListe] = val;
    }
    //print("Lists saved : ");
    //print(listsSaved);
    return listsSaved;
  }

  Future<void> _load() async {
    setState(() {
      _initialized = false;
    });
    UserConnected user = await getUser();
    setState(() {
      _user = user;
    });
    List<Listes> pc = await user.getListsCreated();
    List<Listes> pl = await user.getListsLiked();
    setState(() {
      _createdLists = pc;
      _savedLists = pl;
    });
    Map<dynamic, dynamic> mpc = await _getPostListCreatedForDashboard();
    Map<dynamic, dynamic> mpl = await _getPostListLikedForDashboard();
    setState(() {
      _mapCreatedList = mpc;
      _mapSavedList = mpl;
    });

    setState(() {
      _initialized = true;
    });
  }

  Widget _tqtCestDeLaTriche(BuildContext context) {
    return const SizedBox(
      height: footerHeight + 10.0,
    );
  }
}
