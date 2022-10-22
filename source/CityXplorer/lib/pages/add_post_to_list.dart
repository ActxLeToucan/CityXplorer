import 'dart:convert';

import 'package:cityxplorer/models/listes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../components/appbar.dart';
import '../conf.dart';
import '../main.dart';
import '../models/post.dart';
import '../models/user_connected.dart';
import '../router/delegate.dart';
import '../styles.dart';

class AddPostToList extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const AddPostToList({Key? key, required this.arguments}) : super(key: key);

  @override
  State<AddPostToList> createState() => _AddPostToListState();
}

class _AddPostToListState extends State<AddPostToList> {
  final routerDelegate = Get.find<MyRouterDelegate>();
  List<Listes> _createdLists = [];

  final TextEditingController titre = TextEditingController();
  final TextEditingController description = TextEditingController();

  UserConnected _user = UserConnected.empty();
  Post _post = Post.empty();
  bool _initialized = false;

  @override
  void initState() {
    Post.fromId(widget.arguments['id'].toString()).then((post) {
      getUser().then((u) {
        setState(() {
          _post = post;
          _load();
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      if (_post.isEmpty()) {
        return Scaffold(
            backgroundColor: (Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground),
            appBar: defaultAppBar(context),
            body: Center(
                child: Text(
              "Post invalid.",
              style: TextStyle(
                  color: (Styles.darkMode
                      ? Styles.darkTextColor
                      : Styles.lightTextColor)),
            )));
      } else {
        List<Widget> mesListes = []; //Listes crées
        for (var element in _createdLists) {
          mesListes.add(_renderTextButton(element.nomListe, element.id));
        }
        return Scaffold(
            backgroundColor: (Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground),
            appBar: defaultAppBar(context),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: mesListes,
            ));
      }
    } else {
      return Scaffold(
          backgroundColor: (Styles.darkMode
              ? Styles.darkBackground
              : Styles.lightBackground),
          appBar: defaultAppBar(context),
          body: const Center(child: CircularProgressIndicator()));
    }
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
    setState(() {
      _createdLists = pc;
    });
    setState(() {
      _initialized = true;
    });
  }

  Widget _renderTextButton(String s, int id) {
    return TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
        ),
        onPressed: () => _sendPostToList(_post.id, id),
        child: Text(s));
  }

  Future<void> _sendPostToList(int idPost, int idList) async {
    var tk = _user.token;
    String url =
        Conf.domainApi + "/postList?idPost=$idPost&idList=$idList&token=$tk";
    try {
      var response = await http
          .post(Uri.parse(url), headers: {'content-type': 'application/json'});
      final Map<String, dynamic> data = json.decode(response.body);

      Fluttertoast.showToast(
          backgroundColor: Styles.mainColor, msg: data['message']);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          backgroundColor: Styles.darkMode ? Styles.darkRed : Colors.redAccent,
          msg: "Impossible d'accéder à la base de données.");
    }
  }
}
