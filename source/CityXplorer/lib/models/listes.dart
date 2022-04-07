import 'dart:convert';

import 'package:cityxplorer/models/post.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../styles.dart';

class Listes {
  final int id;
  final String nomListe;
  final String description;
  final String pseudoCreateur;

  const Listes(
      {required this.id,
      required this.nomListe,
      required this.description,
      required this.pseudoCreateur});

  factory Listes.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();
    return Listes(
        id: json['isListe'] is String
            ? int.parse(json['idListe'])
            : json['idListe'],
        nomListe: unescape.convert(json['nomListe']),
        description: json['descrListe'],
        pseudoCreateur: json['pseudo']);
  }

  static Future<Listes> fromId(String id) async {
    Listes liste = Listes.empty();

    String url = Conf.domainServer + Conf.apiPath + "/list?id=$id";
    try {
      var response = await http.get(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);
      var res = data['result'];

      if (res == 1) {
        liste = Listes.fromJson(data['list']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          backgroundColor: Styles.darkMode ? Styles.darkRed : Colors.redAccent,
          msg: "Impossible d'accéder à la base de données.");
    }

    return liste;
  }

  factory Listes.empty() {
    return const Listes(
        id: -1, nomListe: "", description: "", pseudoCreateur: "");
  }

  bool isEmpty() {
    return (id == -1);
  }

  Future<List<Post>> getPostsOfList() async {
    List<Post> posts = [];
    String url = Conf.domainServer + Conf.apiPath + "/postFromList?idList=$id";
    try {
      var response = await http.get(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);
      //print("ForEach ici");
      if (data['result'] == 1) {
        List<dynamic> postsJson = data["listPost"];
        for (var e in postsJson) {
          posts.add(Post.fromJson(e));
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Listes && runtimeType == other.runtimeType && id == other.id;
}
