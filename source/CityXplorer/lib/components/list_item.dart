import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../conf.dart';
import '../models/listes.dart';
import '../models/post.dart';
import '../router/delegate.dart';
import '../styles.dart';

class ListeItem extends StatefulWidget {
  Listes liste;
  bool liked;
  String url;

  ListeItem(
      {Key? key, required this.liste, required this.liked, required this.url})
      : super(key: key);

  @override
  State<ListeItem> createState() => _ListeItemState();
}

class _ListeItemState extends State<ListeItem> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  bool _liked = false;

  @override
  void initState() {
    super.initState();
    setState(() => _liked = widget.liked);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: MaterialButton(
      onPressed: () => routerDelegate.pushPage(
          name: '/list', arguments: {'id': widget.liste.id.toString()}),
      child: ListTile(
        title: Text(widget.liste.nomListe),
        subtitle: Text(widget.liste.description),
        iconColor: Styles.mainColor,
        trailing: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(_liked ? Icons.check : Icons.add),
          onPressed: changeState,
        ),
        leading: widget.url != ""
            ? Image.network("${Conf.domainServer}/img/posts/${widget.url}")
            : Image.asset('assets/default.jpg'),
      ),
    ));
  }

  // TODO
  void changeState() {
    setState(() {
      _liked = !_liked;
    });
  }
}
