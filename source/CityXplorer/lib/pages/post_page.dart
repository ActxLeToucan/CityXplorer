import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';

import '../components/appbar.dart';
import '../models/post.dart';

class PostPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const PostPage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Post _post = Post.empty();
  UserConneted _user = UserConneted.empty();
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
            appBar: defaultAppBar(context),
            body: const Center(child: Text("Post invalide.")));
      } else {
        return Scaffold(
          appBar: defaultAppBar(context),
          body: SingleChildScrollView(
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
        );
      }
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Chargement...',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: const Center(child: CircularProgressIndicator()));
    }
  }
}
