import 'dart:convert';

import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/components/input_field.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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

  final _formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();

  UserConnected _user = UserConnected.empty();
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
            backgroundColor: Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground,
            extendBodyBehindAppBar: true,
            appBar: transparentAppBar(context),
            body: Center(
                child: Text(
              "Connectez-vous pour accéder à cette page",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Styles.darkMode
                    ? Styles.darkTextColor
                    : Styles.lightTextColor,
              ),
            )));
      } else {
        return Scaffold(
            backgroundColor: Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground,
            extendBodyBehindAppBar: true,
            appBar: transparentAppBar(context),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 15, 32, 0),
                child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    ProfileWidget(
                      user: _user,
                      isEdit: true,
                      onClicked: changeAvatar,
                    ),
                    const SizedBox(height: 24),
                    InputField(
                      controller: name,
                      hintText: "Nom",
                      hintPosition: HintPosition.above,
                      withBottomSpace: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Entrez un nom';
                        }
                        if (value.length < Conf.tailleNameMin) {
                          return "Ce nom est trop court";
                        }
                        if (value.length > Conf.tailleNameMax) {
                          return "Ce nom est trop long";
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
                      onPressed: editProfile,
                    ),
                    const SizedBox(height: 25),
                    Button(
                      type: ButtonType.small,
                      text: "Changer de mot de passe",
                      onPressed: () =>
                          routerDelegate.pushPage(name: '/change_password'),
                    ),
                    Button(
                      type: ButtonType.small,
                      text: "Supprimer mon compte",
                      contentColor: Styles.darkRed,
                      onPressed: () => alertDelete(context),
                    ),
                  ],
                ),
              ),
            ));
      }
    } else {
      return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: transparentAppBar(context),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> changeAvatar() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _initialized = false;
    });
    String url = Conf.domainApi + "/avatar";
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields['token'] = _user.token;

    try {
      request.files
          .add(await http.MultipartFile.fromPath("avatar", image.path));

      var response = await http.Response.fromStream(await request.send());
      final Map<String, dynamic> data = json.decode(response.body);
      String res = data['message'];
      int code = data['result'];

      Fluttertoast.showToast(backgroundColor: Styles.mainColor, msg: res);

      if (code == 1) {
        await updateUser(_user);
        UserConnected newUser = await getUser();
        setState(() {
          _user = newUser;
          _initialized = true;
        });
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Impossible d'accéder à la base de données.",
        backgroundColor: Styles.darkMode ? Styles.darkRed : Colors.redAccent,
      );
    }
    setState(() {
      _initialized = true;
    });
  }

  void alertDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Supprimer"),
            content: const Text(
                "Voulez-vous vraiment supprimer votre compte CityXplorer ? Cette action est irréversible."),
            actions: [
              TextButton(
                child: const Text('Annuler'),
                onPressed: () => routerDelegate.popRoute(),
              ),
              TextButton(
                child: const Text('Supprimer',
                    style: TextStyle(color: Colors.red)),
                onPressed: deleteAccount,
              ),
            ],
          );
        });
  }

  Future<void> editProfile() async {
    if (_formKey.currentState!.validate()) {
      String url = Conf.domainApi + "/user";
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

        Fluttertoast.showToast(
            backgroundColor: Styles.mainColor, msg: data['message']);

        if (data["result"] == 1) {
          await updateUser(_user);
        }
      } catch (e) {
        print(e);
        Fluttertoast.showToast(
            backgroundColor:
                Styles.darkMode ? Styles.darkRed : Colors.redAccent,
            msg: "Impossible d'accéder à la base de données.");
      }
    }
  }

  Future<void> deleteAccount() async {
    String url =
        Conf.domainApi + "/user?pseudo=${_user.pseudo}&token=${_user.token}";

    try {
      var response = await http.delete(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);

      Fluttertoast.showToast(
          backgroundColor: Styles.mainColor, msg: data['message']);

      if (data["result"] == 1) {
        deconnexion();
        routerDelegate.pushPageAndClear(name: '/login');
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          backgroundColor: Styles.darkMode ? Styles.darkRed : Colors.redAccent,
          msg: "Impossible d'accéder à la base de données.");
    }
  }
}
