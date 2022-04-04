import 'package:flutter/material.dart';

import '../components/appbar.dart';
import '../models/user.dart';

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
            appBar: namedAppBar(context, "CityXplorer"),
            body: const Center(
                child: Text("Utilisateur invalide.",
                    textAlign: TextAlign.center)));
      } else {
        return Scaffold(
          appBar: namedAppBar(context, "Listes de @${_user.pseudo}"),
          body: RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _lists,
                ),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
              )),
        );
      }
    } else {
      return Scaffold(
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

  // TODO
  Future<List> getLists(User user) async {
    return [];
  }

  // TODO
  Future<Widget> _renderLists(User user) async {
    List lists = await getLists(user);
    if (lists.isEmpty) {
      return const Center(
        child: Text("Cet utilisateur n'a aucune liste.",
            textAlign: TextAlign.center),
      );
    } else {
      List<ListTile> list = [];
      lists.forEach((element) {
        list.add(element.toListTile());
      });
      return ListView(children: list);
    }
  }
}
