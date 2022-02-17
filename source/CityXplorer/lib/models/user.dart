import 'dart:convert';

import 'package:cityxplorer/models/post.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';

class User {
  final String pseudo;
  final String token;
  final String name;
  final String avatar;
  final int niveauAcces;

  const User(
      {required this.pseudo,
      required this.token,
      required this.name,
      required this.avatar,
      required this.niveauAcces});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        pseudo: json['pseudo'],
        token: json['token'],
        name: json['name'],
        avatar: json['avatar'],
        niveauAcces: json['niveauAcces']);
  }

  factory User.empty() {
    return const User(
        pseudo: "", token: "", name: "", avatar: "", niveauAcces: 0);
  }

  Map<String, dynamic> toJson() {
    return {
      "pseudo": this.pseudo,
      "token": this.token,
      "name": this.name,
      "avatar": this.avatar,
      "niveauAcces": this.niveauAcces
    };
  }

  bool isEmpty() {
    return (pseudo == "");
  }

  Future<List<Post>> getPosts() async {
    List<Post> posts = [];

    String url = Conf.bddDomainUrl + Conf.bddPath + "/posts?user=$pseudo";
    try {
      var response = await http.get(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);

      List dataPosts = data['posts'];
      for (var post in dataPosts) {
        posts.add(Post.fromJson(post));
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }

    return posts;
  }
}
