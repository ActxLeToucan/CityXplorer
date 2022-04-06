import 'dart:convert';

import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../components/description.dart';
import '../conf.dart';
import '../models/listes.dart';
import '../models/post.dart';
import '../router/delegate.dart';
import '../styles.dart';

class PageList extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const PageList({Key? key, required this.arguments}) : super(key: key);

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  bool _initialized = false;

  UserConnected _user = UserConnected.empty();
  Listes _list = Listes.empty();
  Widget _posts = Container();
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      if (_list.isEmpty()) {
        return Scaffold(
            appBar: defaultAppBar(context),
            body: const Center(
                child: Text("Liste invalide.", textAlign: TextAlign.center)));
      } else {
        return Scaffold(
            appBar: defaultAppBar(context),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [_renderHeader(), _posts],
            ));
      }
    } else {
      return Scaffold(
          appBar: defaultAppBar(context),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> _load() async {
    setState(() => _initialized = false);
    UserConnected u = await getUser();
    Listes l = await Listes.fromId(widget.arguments['id']);
    Widget p = await _renderPosts(l);
    List<Listes> listesEnregistrees = await u.getListsLiked();
    setState(() {
      _liked = listesEnregistrees.contains(l);
      _user = u;
      _list = l;
      _posts = p;
      _initialized = true;
    });
  }

  Future<Widget> _renderPosts(Listes liste) async {
    List<Post> p = await liste.getPostsOfList();
    bool isCurrent = await isCurrentUser(_user.pseudo);
    UserConnected _currentUser = await getUser();
    List<Widget> list = [];
    for (Post post in p) {
      if (post.isValid() || _currentUser.niveauAcces >= 2 || isCurrent) {
        list.add(post.toWidget());
      }
    }
    if (list.isEmpty) {
      return const Center(
        child: Text("Cette liste est vide.", textAlign: TextAlign.center),
      );
    }
    return Column(children: list);
  }

  Widget _renderHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: Row(
              children: [
                Expanded(
                    child: Text(_list.nomListe,
                        style: const TextStyle(fontSize: 20))),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(_liked ? Icons.check : Icons.add),
                  color: _user.isEmpty() ? Colors.grey : Styles.mainColor,
                  onPressed: changeState,
                )
              ],
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Description(
              description: _list.description.trim() == ""
                  ? "Pas de descrption"
                  : _list.description,
              defaultColor: Colors.black.withOpacity(0.65)),
        ),
        Center(
          child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () =>
                  Share.share("${Conf.domainServer}/list?id=${_list.id}")),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => routerDelegate.pushPage(
                name: '/user', arguments: {'pseudo': _list.pseudoCreateur}),
            child: Text(
              "@${_list.pseudoCreateur}",
              style: const TextStyle(color: Styles.linkColor),
            ),
          ),
        )
      ],
    );
  }

  Future<void> changeState() async {
    bool fav = _liked;
    if (_user.isEmpty()) {
      Fluttertoast.showToast(
          msg: "Vous devez être connecté pour enregistrer une liste.");
      return;
    }

    String url = Conf.domainServer + Conf.apiPath + "/saved_list";
    Map<String, dynamic> body = {
      "token": _user.token,
      "id": _list.id,
    };

    try {
      var response = fav
          ? await http.delete(Uri.parse(url),
              body: json.encode(body),
              headers: {'content-type': 'application/json'})
          : await http.post(Uri.parse(url),
              body: json.encode(body),
              headers: {'content-type': 'application/json'});
      final Map<String, dynamic> data = json.decode(response.body);

      Fluttertoast.showToast(msg: data['message']);

      if (data['result'] == 1) {
        setState(() {
          _liked = !fav;
        });
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }
  }
}
