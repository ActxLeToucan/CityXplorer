import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';

import '../components/appbar.dart';
import '../models/post.dart';
import '../styles.dart';

class PostPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const PostPage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Post _post = Post.empty();
  UserConnected _user = UserConnected.empty();
  bool _loaded = false;

  @override
  void initState() {
    Post.fromId(widget.arguments['id'].toString()).then((post) {
      getUser().then((u) {
        setState(() {
          _user = u;
          _post = post;
          _loaded = true;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_loaded) {
      if (_post.isEmpty()) {
        return Scaffold(
            backgroundColor: (Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground),
            appBar: defaultAppBar(context),
            body: Center(
                child: Text(
              "Post invalide.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Styles.darkMode
                      ? Styles.darkTextColor
                      : Styles.lightTextColor),
            )));
      } else if (_post.etat == Post.postEtatBloque &&
          _user.niveauAcces < 2 &&
          _user.pseudo != _post.userPseudo) {
        return Scaffold(
            backgroundColor: (Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground),
            appBar: defaultAppBar(context),
            body: Center(
                child: Text("Post bloqué.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Styles.darkMode
                            ? Styles.darkTextColor
                            : Styles.lightTextColor))));
      } else {
        return Scaffold(
            backgroundColor: (Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground),
            appBar: defaultAppBar(context),
            body: RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        child: _post.elementsBeforeImageOnPage(_user),
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0)),
                    _post.renderImageOnPage(),
                    Padding(
                      child: _post.elementsAfterImageOnPage(context),
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    )
                  ],
                ),
              ),
            ));
      }
    } else {
      return Scaffold(
          backgroundColor: (Styles.darkMode
              ? Styles.darkBackground
              : Styles.lightBackground),
          appBar: namedAppBar(context, "Chargement..."),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> _load() async {
    setState(() => _loaded = false);
    Post p = await Post.fromId(widget.arguments['id'].toString());

    setState(() {
      _post = p;
      _loaded = true;
    });
  }
}
