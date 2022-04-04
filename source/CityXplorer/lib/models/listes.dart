import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cityxplorer/components/description.dart';
import 'package:cityxplorer/components/icon_menu_post_profil.dart';
import 'package:cityxplorer/components/share_bar_icon.dart';
import 'package:cityxplorer/models/post.dart';
import 'package:cityxplorer/models/user.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../router/delegate.dart';
import '../main.dart';
import '../styles.dart';

class Listes {
  final int id;
  final String nomListe;
  final String Description;
  final int idCreateur;


  const Listes({required this.id,
    required this.nomListe,
    required this.Description,
    required this.idCreateur});

  factory Listes.fromJson(Map<String, dynamic> json){
    var unescape = HtmlUnescape();
    return Listes(
        id: json['idListe'],
        nomListe: unescape.convert(json['nomListe']),
        Description: json['descrListe'],
        idCreateur: json['idCreateur']);
  }

  factory Listes.empty(){
    return const Listes(id: -1,
        nomListe: "",
        Description: "",
        idCreateur: -1);
  }

  bool isEmpty() {
    return (nomListe == "");
  }

  Future<List<Post>> getPostsOfList(User user) async {
    List<Post> posts = [];
    String url = Conf.domainServer + Conf.apiPath +
        "/postFromList?idList=${id}&pseudo=${user.pseudo}";
    try {
      var response = await http.get(Uri.parse(url));
      final Map<String,dynamic> data = json.decode(response.body);
      //print("ForEach ici");
      var res = data["listPost"];
      print(res);
      res.foreach ((e ) {
        posts.add(Post.fromJson(e));
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données ici.");
    }
    print("Tab des posts");
    print(posts);
    return posts;
  }
}
