import 'dart:async';
import 'dart:convert';

import 'package:cityxplorer/models/post.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../router/delegate.dart';
import 'listes.dart';

class User {
  final String pseudo;
  final String name;
  final String avatar;
  final int niveauAcces;
  final String description;
  final List<int?> likes;

  const User(
      {required this.pseudo,
      required this.name,
      required this.avatar,
      required this.niveauAcces,
      required this.description,
      required this.likes});

  factory User.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();
    return User(
        pseudo: unescape.convert(json['pseudo']),
        name: unescape.convert(json['name']),
        avatar: json['avatar'],
        niveauAcces: json['niveauAcces'],
        description: unescape.convert(json['description']),
        likes: List<int>.from(json['likes']));
  }

  factory User.empty() {
    return const User(
        pseudo: "",
        name: "",
        avatar: "",
        niveauAcces: 0,
        description: "",
        likes: []);
  }

  static Future<User> fromPseudo(String pseudo) async {
    User user = User.empty();

    String url = Conf.domainServer + Conf.apiPath + "/user?pseudo=$pseudo";
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
      "pseudo": pseudo,
      "name": name,
      "avatar": avatar,
      "niveauAcces": niveauAcces,
      "description": description,
      "likes": likes
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  bool isEmpty() {
    return (pseudo == "");
  }

  Future<List<Post>> getPosts() async {
    List<Post> posts = [];

    String url = Conf.domainServer + Conf.apiPath + "/postsUser?pseudo=$pseudo";
    try {
      var response = await http.get(Uri.parse(url));
      final List<dynamic> data = json.decode(response.body);

      posts = List<Post>.from(data.map((model) => Post.fromJson(model)));
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }

    return posts;
  }

  Future<List<Post>> getLikedPosts() async {
    List<Post> posts = [];

    String url =
        Conf.domainServer + Conf.apiPath + "/liked_posts?pseudo=$pseudo";
    try {
      var response = await http.get(Uri.parse(url));
      final List<dynamic> data = json.decode(response.body);

      posts = List<Post>.from(data.map((model) => Post.fromJson(model)));
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }

    return posts;
  }

  Future<List<Listes>> getListsCreated() async {
    List<Listes> lists = [];

    String url =
        Conf.domainServer + Conf.apiPath + "/listCreatedUser?pseudo=$pseudo";

    try {
      var response = await http.get(Uri.parse(url));
      //print("Problème dans Lists created");
      //print(response.body);
      final List<dynamic> data = json.decode(response.body);

      lists = List<Listes>.from(data.map((model) => Listes.fromJson(model)));
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }
    return lists;
  }

  Future<List<Listes>> getListsLiked() async {
    List<Listes> lists = [];

    String url =
        Conf.domainServer + Conf.apiPath + "/listLikedUser?pseudo=$pseudo";

    try {
      var response = await http.get(Uri.parse(url));
      //print("Problème dans Lists liked");
      final List<dynamic> data = json.decode(response.body);

      lists = List<Listes>.from(data.map((model) => Listes.fromJson(model)));
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Impossible d'accéder à la base de données par ici.");
    }
    return lists;
  }

  void pushPage() {
    final routerDelegate = Get.find<MyRouterDelegate>();
    routerDelegate.pushPage(name: '/user', arguments: {'pseudo': pseudo});
  }

  void pushPageLists() {
    final routerDelegate = Get.find<MyRouterDelegate>();
    routerDelegate.pushPage(name: '/lists', arguments: {'pseudo': pseudo});
  }
}
