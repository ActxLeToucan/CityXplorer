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
  State<UserProfile> createState() => _UserProfileState(user);
}

class _UserProfileState extends State<UserProfile> {
  User user;
  bool loading = false;
  Widget postsLoaded = Container();
  Widget userInfos = Container();

  _UserProfileState(this.user);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    _updateUser();
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
    return Column(
      children: [
        ProfileWidget(
            user: user,
            onClicked: () async {
              UserConneted userConneted = UserConneted.empty();
              if (user is UserConneted) {
                userConneted = (user as UserConneted);
              } else if (await isCurrentUser(user.pseudo)) {
                userConneted = await getUser();
              }
              if (!userConneted.isEmpty()) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditProfilePage(user: userConneted)));
              }
            }),
        const SizedBox(height: 24),
        buildName(user),
        const SizedBox(height: 24),
        NumbersWidget(user: user),
        const SizedBox(height: 48),
        buildAbout(user),
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
    List<Post> posts = await user.getPosts();
    bool isCurrent = await isCurrentUser(user.pseudo);
    if (posts.isEmpty) {
      return const Center(
        child: Text("Aucun post n'a été publié par cet utilisateur."),
      );
    } else {
      List<Widget> list = [];
      for (Post post in posts) {
        if (post.isValid() || user.niveauAcces >= 2 || isCurrent) {
          list.add(post.toWidget(context));
        }
      }
      return Column(children: list);
    }
  }

  void _updateUser() async {
    if ((!user.isEmpty() && user is UserConneted) ||
        await isCurrentUser(user.pseudo)) {
      UserConneted userConneted = await getUser();
      User newUser = await User.fromPseudo(user.pseudo);
      UserConneted userUpdated = userConneted.updateWith(newUser);
      user = userUpdated;
      connexion(userUpdated);
    }
  }
}
