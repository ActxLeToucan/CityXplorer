import 'package:flutter/material.dart';

class Post {
  final int id;
  final List<String> photos;
  final DateTime date;
  final double positionX;
  final double positionY;
  final String
      userPseudo; // dépendra de l'api, est ce qu'on travaille avec juste le pseudo ou directement avec l'objet User ?

  const Post(
      {required this.id,
      required this.photos,
      required this.date,
      required this.positionX,
      required this.positionY,
      required this.userPseudo});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        photos: json['photos'],
        date: json['date'],
        positionX: json['positionX'],
        positionY: json['positionY'],
        userPseudo: json['user-pseudo']);
  }

  //TODO
  Widget toSmallWidget() {
    return Text("TODO");
  }

  //TODO
  Widget toBigWidget() {
    throw Exception("TODO");
  }
}
