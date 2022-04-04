import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../components/appbar.dart';
import '../components/input_field.dart';
import '../conf.dart';
import '../main.dart';
import '../models/post.dart';
import '../models/user_connected.dart';
import '../router/delegate.dart';

class PostEdit extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const PostEdit({Key? key, required this.arguments}) : super(key: key);

  @override
  State<PostEdit> createState() => _PostEditState();
}

class _PostEditState extends State<PostEdit> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController titre = TextEditingController();
  final TextEditingController description = TextEditingController();

  UserConnected _user = UserConnected.empty();
  Post _post = Post.empty();
  bool _initialized = false;

  @override
  void initState() {
    Post.fromId(widget.arguments['id'].toString()).then((post) {
      getUser().then((u) {
        setState(() {
          _user = u;
          _post = post;
          titre.text = post.titre;
          description.text = post.description;
          _initialized = true;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      if (_post.isEmpty()) {
        return Scaffold(
            appBar: defaultAppBar(context),
            body: const Center(
                child: Text("Post invalide.", textAlign: TextAlign.center)));
      } else if (_user.isEmpty() || _user.pseudo != _post.userPseudo) {
        return Scaffold(
            appBar: defaultAppBar(context),
            body: const Center(
                child: Text(
                    "Vous devez être le propriétaire du post pour accéder à cette page",
                    textAlign: TextAlign.center)));
      } else {
        return Scaffold(
            appBar: defaultAppBar(context),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 15, 32, 0),
                child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    InputField(
                      controller: titre,
                      hintText: "Titre",
                      hintPosition: HintPosition.above,
                      withBottomSpace: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Donnez un titre à votre post';
                        }
                        if (value.length >= Conf.tailleTitreMax) {
                          return 'Ce titre est trop long';
                        }
                        return null;
                      },
                    ),
                    InputField(
                        controller: description,
                        hintText: "Description",
                        hintPosition: HintPosition.above,
                        minLines: 2,
                        maxLines: 5,
                        withBottomSpace: true),
                    Button(
                      type: ButtonType.big,
                      text: "Valider les changements",
                      withLoadingAnimation: true,
                      onPressed: editPost,
                    ),
                  ],
                ),
              ),
            ));
      }
    } else {
      return Scaffold(
          appBar: defaultAppBar(context),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> editPost() async {
    if (_formKey.currentState!.validate()) {
      String url = Conf.domainServer + Conf.apiPath + "/post";
      Map<String, dynamic> body = {
        "token": _user.token,
        "id": _post.id,
        "titre": titre.text,
        "description": description.text.trim(),
      };

      try {
        var response = await http.put(Uri.parse(url),
            body: json.encode(body),
            headers: {'content-type': 'application/json'});
        final Map<String, dynamic> data = json.decode(response.body);

        Fluttertoast.showToast(msg: data['message']);
      } catch (e) {
        print(e);
        Fluttertoast.showToast(
            msg: "Impossible d'accéder à la base de données.");
      }
    }
  }
}
