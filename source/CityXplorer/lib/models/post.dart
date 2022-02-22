import 'package:cityxplorer/components/icon_menu_post_profil.dart';
import 'package:cityxplorer/components/share_bar_icon.dart';
import 'package:cityxplorer/models/user.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import '../components/appbar_default.dart';
import '../conf.dart';
import '../styles.dart';

class Post {
  final int id;
  final String titre;
  final double latitude;
  final double longitude;
  final String description;
  final DateTime date;
  final String etat;
  final List<String?> photos;
  final String userPseudo;

  const Post(
      {required this.id,
      required this.titre,
      required this.latitude,
      required this.longitude,
      required this.description,
      required this.date,
      required this.etat,
      required this.photos,
      required this.userPseudo});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        titre: json['titre'],
        latitude: (json['latitude'] is int
            ? (json['latitude'] as int).toDouble()
            : json['latitude']),
        longitude: (json['longitude'] is int
            ? (json['longitude'] as int).toDouble()
            : json['longitude']),
        description: json['description'],
        date: (json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now()),
        etat: (json['etat'] as String).toLowerCase(),
        photos: List<String>.from(json['photos']),
        userPseudo: json['user-pseudo']);
  }

  bool isValid() {
    return etat.compareTo("valide") == 0;
  }

  Widget toWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => toPage(context)));
      },
      child: Container(
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
            _renderImageOnWidget(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: _elementsAfterImageOnWidget(),
            )
          ],
        ),
      ),
    );
  }

  Widget _elementsBeforeImageOnWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            titre,
            overflow: TextOverflow.fade,
            softWrap: false,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        Row(children: [
          Expanded(
              child: Text(
            "ville", //TODO ville
            style: const TextStyle(color: Colors.black45),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )),
          Text(
            "le ${date.day}/${date.month}/${date.year}",
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
                        "${Conf.bddDomainUrl}/img/posts/${photos[0]}",
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
            child: const ShareBar(),
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

  Scaffold toPage(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                child: _elementsBeforeImageOnPage(),
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0)),
            _renderImageOnPage(),
            Padding(
              child: _elementsAfterImageOnPage(context),
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            )
          ],
        ),
      ),
    );
  }

  Widget _elementsBeforeImageOnPage() {
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
              const IconMenuPost(),
            ]),
        Text(
          // TODO ville
          "ville, le ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}.",
          style: const TextStyle(color: Colors.black45),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
          child: Text(
              photos.length != 1 ? "${photos.length} photos" : "1 photo",
              style: const TextStyle(color: Colors.black45)),
        ),
      ],
    );
  }

  Widget _renderImageOnPage() {
    return CarouselSlider(
      items: photos.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network("${Conf.bddDomainUrl}/img/posts/$i"));
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

  Widget _elementsAfterImageOnPage(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: const ShareBar(),
          ),
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
            child: Text("@$userPseudo", style: Styles.textStyleLink),
          ),
          onTap: () => navigateToCreatorPage(context),
        ),
        Text(description)
      ],
    );
  }

  Future<void> navigateToCreatorPage(BuildContext context) async {
    User user = await User.fromPseudo(userPseudo);
    if (!user.isEmpty()) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => user.profile()));
    }
  }
}
