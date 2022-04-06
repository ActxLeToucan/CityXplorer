import 'package:cityxplorer/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/post.dart';
import '../router/delegate.dart';
import '../styles.dart';

class NumbersWidget extends StatefulWidget {
  final User user;

  const NumbersWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<NumbersWidget> createState() => _NumbersWidgetState();
}

class _NumbersWidgetState extends State<NumbersWidget> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  int nbPosts = 0;
  int nbListes = 0;
  int likes = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(context, nbPosts.toString(),
            'Post${nbPosts > 1 ? 's' : ''}', () {}),
        buildDivider(),
        buildButton(
            context,
            nbListes.toString(),
            'Liste${nbListes > 1 ? 's' : ''}',
            () => routerDelegate.pushPage(
                name: '/lists', arguments: {'pseudo': widget.user.pseudo})),
        buildDivider(),
        buildButton(
            context, likes.toString(), 'Like${likes > 1 ? 's' : ''}', () {}),
      ],
    );
  }

  Widget buildDivider() => const SizedBox(
        height: 24,
        child: VerticalDivider(color: Colors.grey),
      );

  Widget buildButton(BuildContext context, String value, String text,
          VoidCallback function) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: function,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Styles.darkMode
                      ? Styles.darkTextColor
                      : Styles.lightTextColor),
            ),
            const SizedBox(height: 2),
            Text(text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Styles.darkMode
                        ? Styles.darkTextColor
                        : Styles.lightTextColor)),
          ],
        ),
      );

  void _load() async {
    List<Post> posts = await widget.user.getPosts();
    nbPosts = posts.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.isValid() ? 1 : 0));
    nbListes = (await widget.user.getListsCreated()).length;
    likes = posts.fold(
        0,
        (previousValue, element) =>
            previousValue + element.likedByUsers.length);

    setState(() {});
  }
}
