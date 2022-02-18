import 'package:cityxplorer/components/appbar_default.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/user.dart';

class UserProfile extends StatelessWidget {
  User user;

  UserProfile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildDefaultAppBar(context),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(10.0),
                child: Center(child: Text("Posts de @${user.pseudo} :"))),
            FutureBuilder<Widget>(
              future: _renderPosts(context),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.requireData;
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            Post(
                    id: -1,
                    date: DateTime.parse("2020-12-24"),
                    photos: ["1.jpg", "2.jpg", "3.jpg"],
                    positionX: 10.0,
                    positionY: 10.0,
                    userPseudo: "antoine54",
                    titre: "Le titre :)",
                    description:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ac ex ullamcorper, iaculis nisl id, maximus augue. Morbi condimentum dui tellus, quis fermentum ante interdum eget. Proin et turpis leo. Praesent ac quam malesuada, sollicitudin eros vulputate, pharetra ligula. Vestibulum pellentesque ligula euismod nulla elementum lobortis. Suspendisse eget dictum nibh.",
                    ville: "Nancy")
                .toWidget(context),
            Post(
                    id: -1,
                    date: DateTime.parse("2020-12-24 16:24"),
                    photos: ["2.jpg", "1.jpg", "3.jpg"],
                    positionX: 10.0,
                    positionY: 10.0,
                    userPseudo: "antoine54",
                    titre:
                        "Le titre giga long long long long long long, Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                    description:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ac ex ullamcorper, iaculis nisl id, maximus augue. Morbi condimentum dui tellus, quis fermentum ante interdum eget. Proin et turpis leo. Praesent ac quam malesuada, sollicitudin eros vulputate, pharetra ligula. Vestibulum pellentesque ligula euismod nulla elementum lobortis. Suspendisse eget dictum nibh.",
                    ville:
                        "Nancy a a a a  a a a a a aaaaaa a a aaaaaaaaaaaaa, Lorem ipsum dolor sit amet, consectetur adipiscing elit. ")
                .toWidget(context)
          ]),
        ));
  }

  Future<Widget> _renderPosts(BuildContext context) async {
    List<Post> posts = await user.getPosts();
    if (posts.isEmpty) {
      return const Text("Aucun post publié par cet utilisateur.");
    } else {
      List<Widget> list = [];
      for (Post post in posts) {
        list.add(post.toWidget(context));
      }
      return Column(children: list);
    }
  }
}
