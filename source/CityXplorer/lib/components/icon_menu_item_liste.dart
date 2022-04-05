import 'package:cityxplorer/models/post.dart';
import 'package:cityxplorer/router/delegate.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:share_plus/share_plus.dart';

import '../conf.dart';

// menu de boutons lorsque l on clique sur les 3 points d une tuile d un post dans une liste du dashboard
class IconMenu extends StatefulWidget {
  final Post post;
  const IconMenu({Key? key,required this.post}) : super(key: key);

  @override
  State<IconMenu> createState() => _IconMenuState();
}

class _IconMenuState extends State<IconMenu> {
  final routerDelegate = Get.find<MyRouterDelegate>();
  @override
  Widget build(BuildContext context) {
    var postId=widget.post.id;
    return PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.remove_red_eye,
                  size: 15.0,),
                  title: Text('Aperçu'),
                  onTap: ()=>routerDelegate.pushPage(name: "/post",
                      arguments: {'id': widget.post.id.toString()}),
                ),
                value: 1,
              ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.share,
                size: 15.0,),
              title: Text('Partager'),
              onTap: ()=>Share.share("${Conf.domainServer}/post?id=${widget.post.id}"),
                ),
                value: 2,
              ),
            ]);
  }
}
