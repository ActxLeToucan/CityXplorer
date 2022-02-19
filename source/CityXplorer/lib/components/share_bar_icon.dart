import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShareBar extends StatefulWidget {
  const ShareBar({Key? key}) : super(key: key);

  @override
  State<ShareBar> createState() => _ShareBarState();
}

// TODO: lier des actions aux boutons
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
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.map),
          iconSize: 28,
          color: Colors.black,
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border),
          iconSize: 28,
          color: Colors.red[400],
          onPressed: () {
            setState(() {
              _isFavorited = !_isFavorited;
              if(_isFavorited){
                Fluttertoast.showToast(msg: "Ajouté aux favoris");
              }else{
                Fluttertoast.showToast(msg: "Retiré des favoris");
              }
            });
          },
        ),
      ],
    );
  }
}
