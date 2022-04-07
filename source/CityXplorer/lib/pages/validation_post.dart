import 'dart:convert';

import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../models/post.dart';
import '../styles.dart';

class ValidationPost extends StatefulWidget {
  const ValidationPost({Key? key}) : super(key: key);

  @override
  State<ValidationPost> createState() => _ValidationPostState();
}

class _ValidationPostState extends State<ValidationPost> {
  UserConnected _user = UserConnected.empty();
  Widget _posts = Container();

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
            appBar: defaultAppBar(context),
            body: Center(
                child: Text(
                    "Vous devez être connecté pour accéder à cette page.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Styles.darkMode
                            ? Styles.darkTextColor
                            : Styles.lightTextColor))));
      } else if (_user.niveauAcces < 2) {
        return Scaffold(
            backgroundColor: Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground,
            appBar: defaultAppBar(context),
            body: Center(
                child: Text(
              "Vous n'avez pas les permissions suffisantes pour accéder à cette page.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Styles.darkMode
                      ? Styles.darkTextColor
                      : Styles.lightTextColor),
            )));
      } else {
        return Scaffold(
          backgroundColor:
              Styles.darkMode ? Styles.darkBackground : Styles.lightBackground,
          appBar: namedAppBar(context, "Posts en attente"),
          body: RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _posts,
                ),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
              )),
        );
      }
    } else {
      return Scaffold(
          backgroundColor:
              Styles.darkMode ? Styles.darkBackground : Styles.lightBackground,
          appBar: namedAppBar(context, "Posts en attente"),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> _load() async {
    setState(() => _initialized = false);

    UserConnected u = await getUser();
    Widget p = await _renderPosts(u);

    setState(() {
      _user = u;
      _posts = p;
      _initialized = true;
    });
  }

  Future<List<Post>> getPosts(UserConnected user) async {
    List<Post> posts = [];
    String url =
        Conf.domainServer + Conf.apiPath + "/pending_posts?token=${user.token}";
    try {
      var response = await http.get(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);

      Fluttertoast.showToast(
          backgroundColor: Styles.mainColor, msg: data['message']);

      if (data['result'] == 1) {
        List<dynamic> postsJson = data['posts'];
        for (var element in postsJson) {
          posts.add(Post.fromJson(element));
        }
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          backgroundColor: Styles.darkMode ? Styles.darkRed : Colors.redAccent,
          msg: "Impossible d'accéder à la base de données.");
    }
    return posts;
  }

  Future<Widget> _renderPosts(UserConnected user) async {
    List<Post> posts = await getPosts(user);
    if (posts.isEmpty) {
      return Center(
        child: Text(
          "Aucun post en attente.",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Styles.darkMode
                  ? Styles.darkTextColor
                  : Styles.lightTextColor),
        ),
      );
    } else {
      List<Widget> list = [];
      for (Post post in posts) {
        list.add(post.toWidget());
      }
      return Column(children: list);
    }
  }
}
