import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';

import '../components/numbers_widget.dart';
import '../components/profile_widget.dart';
import '../models/post.dart';
import '../models/user.dart';

class UserProfile extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const UserProfile({Key? key, required this.arguments}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Widget postsLoaded = Container();
  Widget userInfos = Container();

  User _user = User.empty();
  bool _initialized = false;

  @override
  void initState() {
    User.fromPseudo(widget.arguments['pseudo'].toString()).then((user) {
      setState(() {
        _user = user;
        _initialized = true;
      });
      _load();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      if (_user.isEmpty()) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: transparentAppBar(context),
            body: const Center(child: Text("Utilisateur invalide.")));
      } else {
        updateUser(_user);
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: transparentAppBar(context),
            body: RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 35),
                      child: _userInfos(),
                    ),
                    postsLoaded,
                  ]),
            ));
      }
    } else {
      return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: transparentAppBar(context),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> _load() async {
    setState(() => _initialized = false);
    Widget posts = await _renderPosts(context);
    await updateUser(_user);

    UserConneted user = await getUser();

    setState(() {
      _user = user;
      postsLoaded = posts;
      _initialized = true;
    });
  }

  Widget _userInfos() {
    return Column(
      children: [
        ProfileWidget(
            user: _user,
            onClicked: () async {
              UserConneted userConneted = UserConneted.empty();
              if (_user is UserConneted) {
                userConneted = (_user as UserConneted);
              } else if (await isCurrentUser(_user.pseudo)) {
                userConneted = await getUser();
              }
              if (!userConneted.isEmpty()) {
                userConneted.pushEditPage();
              }
            }),
        const SizedBox(height: 24),
        buildName(_user),
        const SizedBox(height: 24),
        NumbersWidget(user: _user),
        const SizedBox(height: 48),
        buildAbout(_user),
      ],
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            "@${user.pseudo}",
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
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
    List<Post> posts = await _user.getPosts();
    bool isCurrent = await isCurrentUser(_user.pseudo);
    if (posts.isEmpty) {
      return const Center(
        child: Text("Aucun post n'a été publié par cet utilisateur."),
      );
    } else {
      List<Widget> list = [];
      for (Post post in posts) {
        if (post.isValid() || _user.niveauAcces >= 2 || isCurrent) {
          list.add(post.toWidget(context));
        }
      }
      return Column(children: list.reversed.toList());
    }
  }
}
