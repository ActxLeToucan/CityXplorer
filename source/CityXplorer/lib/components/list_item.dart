import 'dart:convert';

import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../conf.dart';
import '../models/listes.dart';
import '../router/delegate.dart';
import '../styles.dart';

class ListeItem extends StatefulWidget {
  final Listes liste;
  final bool liked;
  final String url;
  final UserConnected user;

  const ListeItem(
      {Key? key,
      required this.liste,
      required this.liked,
      required this.url,
      required this.user})
      : super(key: key);

  @override
  State<ListeItem> createState() => _ListeItemState();
}

class _ListeItemState extends State<ListeItem> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  bool _liked = false;

  @override
  void initState() {
    super.initState();
    setState(() => _liked = widget.liked);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: MaterialButton(
      onPressed: () => routerDelegate.pushPage(
          name: '/list', arguments: {'id': widget.liste.id.toString()}),
      child: ListTile(
        title: Text(widget.liste.nomListe),
        subtitle: Text(widget.liste.description),
        iconColor: Styles.mainColor,
        trailing: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(_liked ? Icons.check : Icons.add),
          onPressed: changeState,
        ),
        leading: widget.url != ""
            ? Image.network("${Conf.domainServer}/img/posts/${widget.url}")
            : Image.asset('assets/default.jpg'),
      ),
    ));
  }

  Future<void> changeState() async {
    bool fav = _liked;
    if (widget.user.isEmpty()) {
      Fluttertoast.showToast(
          msg: "Vous devez être connecté pour enregistrer une liste.");
      return;
    }

    String url = Conf.domainServer + Conf.apiPath + "/saved_list";
    Map<String, dynamic> body = {
      "token": widget.user.token,
      "id": widget.liste.id,
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
