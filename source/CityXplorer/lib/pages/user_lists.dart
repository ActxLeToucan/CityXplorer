import 'package:cityxplorer/components/list_item.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';

import '../components/appbar.dart';
import '../main.dart';
import '../models/listes.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../styles.dart';

class UserLists extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const UserLists({Key? key, required this.arguments}) : super(key: key);

  @override
  State<UserLists> createState() => _UserListsState();
}

class _UserListsState extends State<UserLists> {
  User _user = User.empty();
  Widget _lists = Container();

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      if (_user.isEmpty()) {
        return Scaffold(
            backgroundColor: Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground,
            appBar: namedAppBar(context, "CityXplorer"),
            body: Center(
                child: Text("Utilisateur invalide.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Styles.darkMode
                            ? Styles.darkTextColor
                            : Styles.lightTextColor))));
      } else {
        return Scaffold(
          backgroundColor:
              Styles.darkMode ? Styles.darkBackground : Styles.lightBackground,
          appBar: namedAppBar(context, "Listes de @${_user.pseudo}"),
          body: RefreshIndicator(
            onRefresh: _load,
            child: _lists,
          ),
        );
      }
    } else {
      return Scaffold(
          backgroundColor:
              Styles.darkMode ? Styles.darkBackground : Styles.lightBackground,
          appBar: namedAppBar(context, "Chargement..."),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> _load() async {
    setState(() => _initialized = false);
    User u = await User.fromPseudo(widget.arguments['pseudo']);
    Widget l = await _renderLists(u);
    setState(() {
      _user = u;
      _lists = l;
      _initialized = true;
    });
  }

  Future<Widget> _renderLists(User user) async {
    List<Listes> lists = await user.getListsCreated();
    UserConnected userConnected = await getUser();
    List<Listes> listesEnregistrees = await userConnected.getListsLiked();
    if (lists.isEmpty) {
      return const Center(
        child: Text("Cet utilisateur n'a aucune liste.",
            textAlign: TextAlign.center),
      );
    } else {
      List<Widget> list = [];
      for (Listes element in lists) {
        List<Post> posts = await element.getPostsOfList();
        String urlImg = "";
        for (Post p in posts) {
          for (String? url in p.photos) {
            if (url != null && url != "") {
              urlImg = url;
              break;
            }
          }
          if (urlImg != "") break;
        }
        list.add(ListeItem(
          liste: element,
          liked: listesEnregistrees.contains(element),
          url: urlImg,
          user: userConnected,
        ));
      }
      return ListView(
        children: list,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
      );
    }
  }
}
