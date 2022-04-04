import 'dart:convert';

import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';

import '../conf.dart';
import '../models/post.dart';

class ShareBar extends StatefulWidget {
  final Post post;
  const ShareBar({Key? key, required this.post}) : super(key: key);

  @override
  State<ShareBar> createState() => _ShareBarState();
}

class _ShareBarState extends State<ShareBar> {
  bool _isFavorited = false;
  UserConnected user = UserConnected.empty();

  @override
  void initState() {
    super.initState();
    getUser().then((u) => setState(() {
          user = u;
          _isFavorited = (user.likes.contains(widget.post.id));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.share),
          iconSize: 28,
          color: Colors.black,
          onPressed: () =>
              Share.share("${Conf.domainServer}/post?id=${widget.post.id}"),
        ),
        IconButton(
          icon: const Icon(Icons.map),
          iconSize: 28,
          color: Colors.black,
          onPressed: () => widget.post.pushMap(),
        ),
        /*IconButton(
          icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border),
          iconSize: 28,
          color: Colors.red[400],
          onPressed: likePost,
        ),*/
        LikeButton(
            size: 28,
            onTap: likePost,
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                color: _isFavorited ? Colors.redAccent : Colors.grey,
                size: 28,
              );
            })
      ],
    );
  }

  Future<bool?> likePost(bool a) async {
    bool fav = _isFavorited;
    if (user.isEmpty()) {
      Fluttertoast.showToast(
          msg: "Vous devez être connecté pour liker un post.");
      return _isFavorited;
    }

    String url = Conf.domainServer + Conf.apiPath + "/like";
    Map<String, dynamic> body = {
      "token": user.token,
      "id": widget.post.id,
    };

    try {
      var response = fav
          ? await http.delete(Uri.parse(url),
              body: json.encode(body),
              headers: {'content-type': 'application/json'})
          : await http.post(Uri.parse(url),
              body: json.encode(body),
              headers: {'content-type': 'application/json'});
      final Map<String, dynamic> data = json.decode(response.body);

      Fluttertoast.showToast(msg: data['message']);

      if (data['result'] == 1) {
        await reloadUser();
        setState(() {
          _isFavorited = !fav;
        });
      }
      return _isFavorited;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
      return _isFavorited;
    }
  }
}
