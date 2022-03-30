import 'dart:convert';

import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/components/input_field.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../components/profile_widget.dart';
import '../conf.dart';
import '../router/delegate.dart';
import '../styles.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();

  UserConneted _user = UserConneted.empty();
  bool _initialized = false;

  @override
  void initState() {
    getUser().then((user) {
      setState(() {
        _user = user;
        _initialized = true;
        name.text = _user.name;
        description.text = _user.description;
      });
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
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: transparentAppBar(context),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(32, 15, 32, 0),
            child: ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                ProfileWidget(
                  user: _user,
                  isEdit: true,
                  onClicked: () async {}, // TODO
                ),
                const SizedBox(height: 24),
                InputField(
                    controller: name,
                    hintText: "Nom",
                    hintPosition: HintPosition.above,
                    withBottomSpace: true),
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
                  onPressed: editProfile,
                ),
                const SizedBox(height: 25),
                Button(
                  type: ButtonType.small,
                  text: "Changer de mot de passe",
                  onPressed: () {}, // TODO
                ),
                Button(
                  type: ButtonType.small,
                  text: "Supprimer mon compte",
                  contentColor: Styles.darkred,
                  onPressed: () => alertDelete(context),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: transparentAppBar(context),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<bool> alertDelete(BuildContext context) async {
    final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Supprimer"),
            content: const Text(
                "Voulez-vous vraiment supprimer votre compte CityXplorer ? Cette action est irréversible."),
            actions: [
              TextButton(
                child: const Text('Annuler'),
                onPressed: () => Navigator.pop(context, true),
              ),
              TextButton(
                child: const Text(
                  'Supprimer',
                  style: TextStyle(color: Styles.darkred),
                ),
                onPressed: deleteAccount,
              ),
            ],
          );
        });

    return result ?? true;
  }

  Future<void> editProfile() async {
    String url = Conf.domainServer + Conf.apiPath + "/user";
    Map<String, dynamic> body = {
      "token": _user.token,
      "name": name.text,
      "description": description.text,
    };

    try {
      var response = await http.put(Uri.parse(url),
          body: json.encode(body),
          headers: {'content-type': 'application/json'});
      final Map<String, dynamic> data = json.decode(response.body);

      Fluttertoast.showToast(msg: data['message']);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }
  }

  Future<void> deleteAccount() async {
    String url = Conf.domainServer +
        Conf.apiPath +
        "/user?pseudo=${_user.pseudo}&token=${_user.token}";

    try {
      var response = await http.delete(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);

      Fluttertoast.showToast(msg: data['message']);

      if (data["result"] == 1) {
        deconnexion();
        routerDelegate.pushPageAndClear(name: '/login');
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }
  }
}
