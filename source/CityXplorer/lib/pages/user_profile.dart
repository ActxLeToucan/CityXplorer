import 'package:cityxplorer/components/appbar_default.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';

import '../components/numbers_widget.dart';
import '../components/profile_widget.dart';
import '../models/post.dart';
import '../models/user.dart';
import 'edit_profile.dart';

class UserProfile extends StatefulWidget {
  User user;

  UserProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool loading = false;
  Widget postsLoaded = Container();
  Widget userInfos = Container();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildDefaultAppBar(context),
        body: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _renderProgressBar(context),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: _userInfos(),
                ),
                postsLoaded,
                Post(
                        date: DateTime.parse("2020-12-24"),
                        photos: ["1.jpg", "2.jpg"],
                        positionX: 10.0,
                        positionY: 10.0,
                        userPseudo: "antoine54",
                        titre: "Le titre :)",
                        description:
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ac ex ullamcorper, iaculis nisl id, maximus augue. Morbi condimentum dui tellus, quis fermentum ante interdum eget. Proin et turpis leo. Praesent ac quam malesuada, sollicitudin eros vulputate, pharetra ligula. Vestibulum pellentesque ligula euismod nulla elementum lobortis. Suspendisse eget dictum nibh.",
                        ville: "Nancy",
                        etat: "Valide")
                    .toWidget(context),
                Post(
                        date: DateTime.parse("2020-12-24 16:24"),
                        photos: ["2.jpg", "1.jpg", "3.jpg"],
                        positionX: 10.0,
                        positionY: 10.0,
                        userPseudo: "antoine54",
                        titre:
                            "Le titre giga long long long long long long, Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                        description:
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ac ex ullamcorper, iaculis nisl id, maximus augue. Morbi condimentum dui tellus, quis fermentum ante interdum eget. Proin et turpis leo. Praesent ac quam malesuada, sollicitudin eros vulputate, pharetra ligula. Vestibulum pellentesque ligula euismod nulla elementum lobortis. Suspendisse eget dictum nibh.",
                        ville:
                            "Nancy a a a a  a a a a a aaaaaa a a aaaaaaaaaaaaa, Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                        etat: "Invalide")
                    .toWidget(context)
              ]),
        ));
  }

  Future<void> _load() async {
    setState(() => loading = true);
    Widget posts = await _renderPosts(context);
    setState(() {
      postsLoaded = posts;
      loading = false;
    });
  }

  Widget _renderProgressBar(BuildContext context) {
    return (loading
        ? const LinearProgressIndicator(
            value: null,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))
        : Container());
  }

  Widget _userInfos() {
    /*return Text("@${widget.user.pseudo}", style: Styles.textStyleLink));*/
    return Column(
      children: [
        ProfileWidget(
            user: widget.user,
            onClicked: () async {
              UserConneted userConneted = UserConneted.empty();
              if (widget.user is UserConneted) {
                userConneted = (widget.user as UserConneted);
              } else if (await isCurrentUser(widget.user.pseudo)) {
                userConneted = await getUser();
              }
              if (!userConneted.isEmpty()) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditProfilePage(user: userConneted)));
              }
            }),
        const SizedBox(height: 24),
        buildName(widget.user),
        const SizedBox(height: 24),
        NumbersWidget(),
        const SizedBox(height: 48),
        buildAbout(widget.user),
      ],
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            "@${user.pseudo}",
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            user.description == ""
                ? const Text(
                    "Aucune description.",
                    style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic),
                  )
                : Text(
                    user.description,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
          ],
        ),
      );

  Future<Widget> _renderPosts(BuildContext context) async {
    List<Post> posts = await widget.user.getPosts();
    bool isCurrent = await isCurrentUser(widget.user.pseudo);
    if (posts.isEmpty) {
      return const Center(
        child: Text("Aucun post n'a été publié par cet utilisateur."),
      );
    } else {
      List<Widget> list = [];
      for (Post post in posts) {
        if (post.isValid() || widget.user.niveauAcces >= 2 || isCurrent) {
          list.add(post.toWidget(context));
        }
      }
      return Column(children: list);
    }
  }
}
