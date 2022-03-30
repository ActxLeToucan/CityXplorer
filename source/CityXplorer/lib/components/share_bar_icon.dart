import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        IconButton(
          icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border),
          iconSize: 28,
          color: Colors.red[400],
          onPressed: () {
            // TODO
            setState(() {
              _isFavorited = !_isFavorited;
              if (_isFavorited) {
                Fluttertoast.showToast(msg: "Ajouté aux favoris");
              } else {
                Fluttertoast.showToast(msg: "Retiré des favoris");
              }
            });
          },
        ),
      ],
    );
  }
}
