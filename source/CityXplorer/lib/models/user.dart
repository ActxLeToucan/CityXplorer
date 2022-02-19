import 'dart:convert';

import 'package:cityxplorer/models/post.dart';
import 'package:cityxplorer/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';

class User {
  final String pseudo;
  final String name;
  final String avatar;
  final int niveauAcces;

  const User(
      {required this.pseudo,
      required this.name,
      required this.avatar,
      required this.niveauAcces});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        pseudo: json['pseudo'],
        name: json['name'],
        avatar: json['avatar'],
        niveauAcces: json['niveauAcces']);
  }

  factory User.empty() {
    return const User(pseudo: "", name: "", avatar: "", niveauAcces: 0);
  }

  static fromPseudo(String pseudo) async {
    User user = User.empty();

    String url = Conf.bddDomainUrl + Conf.bddPath + "/user?pseudo=$pseudo";
    try {
      var response = await http.get(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);
      var res = data['result'];

      if (res == 1) {
        user = User.fromJson(data['user']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }

    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      "pseudo": this.pseudo,
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

  UserProfile profile() {
    return UserProfile(user: this);
  }
}
