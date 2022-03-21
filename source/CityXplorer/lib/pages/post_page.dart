import 'package:flutter/material.dart';

import '../components/appbar.dart';
import '../models/post.dart';

class PostPage extends StatelessWidget {
  final Post post;

  const PostPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                child: post.elementsBeforeImageOnPage(),
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0)),
            post.renderImageOnPage(),
            Padding(
              child: post.elementsAfterImageOnPage(context),
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            )
          ],
        ),
      ),
    );
  }
}
