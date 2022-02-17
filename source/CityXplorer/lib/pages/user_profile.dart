import 'dart:convert';

import 'package:cityxplorer/components/appbar_default.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../conf.dart';
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
              future: _renderPosts(),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.requireData;
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ]),
        ));
  }

  Future<Widget> _renderPosts() async {
    List<Post> posts = await user.getPosts();
    if (posts.isEmpty) {
      return const Text("Aucun post publié par cet utilisateur.");
    } else {
      List<Widget> list = [];
      for (Post post in posts) {
        list.add(post.toSmallWidget());
      }
      return Column(children: list);
    }
  }
}
