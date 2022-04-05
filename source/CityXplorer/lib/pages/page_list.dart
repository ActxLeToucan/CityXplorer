import 'dart:convert';

import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../conf.dart';
import '../models/listes.dart';
import '../models/post.dart';

class PageList extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const PageList({Key? key, required this.arguments}) : super(key: key);

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
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
      children: [
        Text(_list.nomListe),
        Text(_list.description),
      ],
    );
  }
}
