import 'dart:convert';

import 'package:cityxplorer/models/post.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';

class Listes {
  final int id;
  final String nomListe;
  final String description;
  final int idCreateur;

  const Listes(
      {required this.id,
      required this.nomListe,
      required this.description,
      required this.idCreateur});

  factory Listes.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();
    return Listes(
        id: json['idListe'],
        nomListe: unescape.convert(json['nomListe']),
        description: json['descrListe'],
        idCreateur: json['idCreateur']);
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
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }

    return liste;
  }

  factory Listes.empty() {
    return const Listes(id: -1, nomListe: "", description: "", idCreateur: -1);
  }

  bool isEmpty() {
    return (nomListe == "");
  }

  Future<List<Post>> getPostsOfList() async {
    List<Post> posts = [];
    String url = Conf.domainServer + Conf.apiPath + "/postFromList?idList=$id";
    try {
      var response = await http.get(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);
      print(id);
      print(response.body);
      //print("ForEach ici");
      if (data['result'] == 1) {
        List<dynamic> postsJson = data["listPost"];
        postsJson.forEach((e) {
          posts.add(Post.fromJson(e));
        });
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Impossible d'accéder à la base de données ici.");
    }
    return posts;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Listes && runtimeType == other.runtimeType && id == other.id;
}
