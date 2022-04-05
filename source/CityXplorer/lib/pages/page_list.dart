import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/description.dart';
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
    setState(() {
      _user = u;
      _list = l;
      _posts = p;
      _initialized = true;
    });
  }

  Future<Widget> _renderPosts(Listes liste) async {
    List<Post> p = await liste.getPostsOfList();
    if (p.isEmpty) {
      return const Center(
        child: Text("Cette liste est vide.", textAlign: TextAlign.center),
      );
    } else {
      List<Widget> list = [];
      for (Post post in p) {
        list.add(post.toWidget());
      }
      return Column(children: list);
    }
  }

  Widget _renderHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: Text(_list.nomListe, style: const TextStyle(fontSize: 20))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Description(
              description: _list.description,
              defaultColor: Colors.black.withOpacity(0.65)),
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
}
