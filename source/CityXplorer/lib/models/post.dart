import 'package:cityxplorer/components/share_bar_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../conf.dart';

class Post {
  final int id;
  final List<String> photos;
  final DateTime date;
  final double positionX;
  final double positionY;
  final String
      userPseudo; // dépendra de l'api, est ce qu'on travaille avec juste le pseudo ou directement avec l'objet User ?
  final String titre;
  final String description;
  final String ville;

  const Post(
      {required this.id,
      required this.photos,
      required this.date,
      required this.positionX,
      required this.positionY,
      required this.userPseudo,
      required this.titre,
      required this.description,
      required this.ville});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        photos: json['photos'],
        date: json['date'],
        positionX: json['positionX'],
        positionY: json['positionY'],
        userPseudo: json['user-pseudo'],
        titre: json['titre'],
        description: json['description'],
        ville: json['ville']);
  }

  Widget toSmallWidget() {
    return Container(
      color: Colors.black12,
      margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
                child: Text(
              titre,
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            )),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ]),
          Row(children: [
            Expanded(
                child: Text(
              ville,
              style: const TextStyle(color: Colors.black45),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )),
            Text(
              "le ${date.day}/${date.month}/${date.year}",
              style: const TextStyle(color: Colors.black45),
            )
          ]),
          Stack(
            children: [
              const SizedBox(
                  child: Center(child: CircularProgressIndicator()),
                  height: 300),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  height: 300,
                  constraints: const BoxConstraints(minWidth: 250),
                  child: Image.network(
                      "${Conf.bddDomainUrl}/img/posts/${photos[0]}",
                      fit: BoxFit.cover),
                ),
              )
            ],
          ),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const ShareBar(),
            ),
          ),
          Text(
            description,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          )
        ],
      ),
    );
  }

  //TODO
  Widget toBigWidget() {
    throw Exception("TODO");
  }
}
