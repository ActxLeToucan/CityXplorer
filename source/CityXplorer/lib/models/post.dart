import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cityxplorer/components/description.dart';
import 'package:cityxplorer/components/icon_menu_post_profil.dart';
import 'package:cityxplorer/components/share_bar_icon.dart';
import 'package:cityxplorer/models/user.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../main.dart';
import '../router/delegate.dart';
import '../styles.dart';

class Post {
  static const postEtatValide = 1;
  static const postEtatEnAttente = 0;
  static const postEtatBloque = -1;

  final int id;
  final String titre;
  final double latitude;
  final double longitude;
  final String description;
  final DateTime date;
  final int etat;
  final List<String?> photos;
  final List<String?> likedByUsers;
  final String userPseudo;
  final String adresseCourte;
  final String adresseLongue;

  const Post(
      {required this.id,
      required this.titre,
      required this.latitude,
      required this.longitude,
      required this.description,
      required this.date,
      required this.etat,
      required this.photos,
      required this.likedByUsers,
      required this.userPseudo,
      required this.adresseCourte,
      required this.adresseLongue});

  factory Post.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();
    return Post(
        id: json['id'],
        titre: unescape.convert(json['titre']),
        latitude: (json['latitude'] is int
            ? (json['latitude'] as int).toDouble()
            : json['latitude']),
        longitude: (json['longitude'] is int
            ? (json['longitude'] as int).toDouble()
            : json['longitude']),
        description: unescape.convert(json['description']),
        date: (json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now()),
        etat: json['etat'],
        photos: List<String>.from(json['photos']),
        likedByUsers: List<String>.from(json['likedBy']),
        userPseudo: unescape.convert(json['user-pseudo']),
        adresseCourte: unescape.convert(json['adresse_courte']),
        adresseLongue: unescape.convert(json['adresse_longue']));
  }

  factory Post.empty() {
    return Post(
        id: -1,
        titre: "",
        latitude: .0,
        longitude: .0,
        description: "",
        date: DateTime.now(),
        etat: postEtatEnAttente,
        photos: [],
        likedByUsers: [],
        userPseudo: "",
        adresseCourte: "",
        adresseLongue: "");
  }

  static Future<Post> fromId(String id) async {
    Post post = Post.empty();

    String url = Conf.domainServer + Conf.apiPath + "/post?id=$id";
    try {
      var response = await http.get(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);
      var res = data['result'];

      if (res == 1) {
        post = Post.fromJson(data['post']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }

    return post;
  }

  bool isEmpty() {
    return (id == -1);
  }

  bool isValid() {
    return etat == postEtatValide;
  }

  /// construit l'icone de l'etat du post en fonction de sa valeur
  Widget iconValidation() {
    if (etat == postEtatBloque) {
      return const Icon(
        Icons.cancel_outlined,
        color: Colors.red,
        size: 26,
      );
    } else if (etat == postEtatValide) {
      return const Icon(
        Icons.verified_user,
        color: Colors.green,
        size: 26,
      );
    } else {
      return const Icon(
        Icons.lock_clock,
        color: Colors.orangeAccent,
        size: 26,
      );
    }
  }

  Widget toWidget(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.black12,
      ),
      margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: _elementsBeforeImageOnWidget(),
          ),
          GestureDetector(child: _renderImageOnWidget(), onTap: pushPage),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: _elementsAfterImageOnWidget(),
          )
        ],
      ),
    );
  }

  Widget _elementsBeforeImageOnWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "$titre $titre $titre $titre",
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              )),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: buildVerif(),
              ),
            ],
          ),
        ),
        Row(children: [
          Expanded(
              child: Text(
            adresseCourte,
            style: const TextStyle(color: Colors.black45),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )),
          Text(
            "le ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}",
            style: const TextStyle(color: Colors.black45),
          )
        ])
      ],
    );
  }

  Widget _renderImageOnWidget() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Stack(
          children: [
            const SizedBox(
                child: Center(child: CircularProgressIndicator()), height: 300),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                constraints: const BoxConstraints.expand(height: 300),
                child: (photos.isEmpty
                    ? Image.asset("assets/default.jpg", fit: BoxFit.cover)
                    : Image.network(
                        "${Conf.domainServer}/img/posts/${photos[0]}",
                        fit: BoxFit.cover,
                      )),
              ),
            ),
            Positioned(
              top: 20,
              right: 5,
              child: (photos.length > 1
                  ? Container(
                      child: Text("1/${photos.length}"),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Color(0xBFFFFFFF),
                      ),
                    )
                  : Container()),
            )
          ],
        ),
      ),
    );
  }

  Widget _elementsAfterImageOnWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ShareBar(post: this),
          ),
        ),
        Text(
          description,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        )
      ],
    );
  }

  void pushPage() {
    final routerDelegate = Get.find<MyRouterDelegate>();
    routerDelegate.pushPage(name: '/post', arguments: {'id': id.toString()});
  }

  Widget elementsBeforeImageOnPage(UserConneted userConneted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  titre,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: buildVerif(),
              ),
              IconMenuPost(user: userConneted, post: this),
            ]),
        Text(
          "$adresseLongue\nle ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
          style: const TextStyle(color: Colors.black45),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
          child: Text(
              photos.length > 1
                  ? "${photos.length} photos"
                  : "${photos.length} photo",
              style: const TextStyle(color: Colors.black45)),
        ),
      ],
    );
  }

  Widget renderImageOnPage() {
    return CarouselSlider(
      items: photos.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network("${Conf.domainServer}/img/posts/$i"));
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 400,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget elementsAfterImageOnPage(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ShareBar(post: this),
          ),
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
            child: Text("@$userPseudo",
                style: const TextStyle(color: Styles.linkColor)),
          ),
          onTap: () => navigateToCreatorPage(context),
        ),
        Description(description: description)
      ],
    );
  }

  Future<void> navigateToCreatorPage(BuildContext context) async {
    User user = await User.fromPseudo(userPseudo);
    if (!user.isEmpty()) {
      user.pushPage();
    }
  }

  void pushMap() {
    final routerDelegate = Get.find<MyRouterDelegate>();
    routerDelegate.pushPage(name: '/map', arguments: {'id': id.toString()});
  }

  /// construit l'icone de verification d'un post en fonction de son etat
  Widget buildVerif() {
    return FutureBuilder<User>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
              onTap: () {
                showValidation();
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                child: iconValidation(),
              ));
        } else {
          return const CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Colors.black,
          );
        }
      },
    );
  }

  /// fonction appelée lorsque qu'un utilsateur classique clique sur le bouton de validation
  void showValidation() {
    if (etat == postEtatBloque) {
      Fluttertoast.showToast(
          msg: "Le post a été bloqué par un administrateur 😦 !");
    } else if (etat == postEtatValide) {
      Fluttertoast.showToast(
          msg: "Le post a été validé par un administrateur ✌ !");
    } else {
      Fluttertoast.showToast(
          msg: "Le post n'a pas encore été validé par un administeur 😶 !");
    }
  }
}
