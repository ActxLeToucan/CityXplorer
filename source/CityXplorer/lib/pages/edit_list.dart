import 'dart:convert';

import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/components/input_field.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/listes.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../router/delegate.dart';
import '../styles.dart';

class EditListPage extends StatefulWidget {
  final Map<String, dynamic> arguments;
  const EditListPage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<EditListPage> createState() => _EditListState();
}

class _EditListState extends State<EditListPage> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController titre = TextEditingController();
  final TextEditingController description = TextEditingController();

  UserConnected _user = UserConnected.empty();
  Listes _list = Listes.empty();
  bool _initialized = false;

  @override
  void initState() {
    getUser().then((user) {
      setState(() {
        _user = user;
        _initialized = true;
        _list = widget.arguments['list'];
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
            appBar: defaultAppBar(context),
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
                          return 'Entrez un titre';
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
                      onPressed: editList,
                    ),
                  ],
                ),
              ),
            ));
      }
    } else {
      return Scaffold(
          backgroundColor:
              Styles.darkMode ? Styles.darkBackground : Styles.lightBackground,
          appBar: defaultAppBar(context),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  //à implémenter
  Future<void> editList() async {
    if (_formKey.currentState!.validate()) {
      String url = Conf.domainApi + "/list";
      Map<String, dynamic> body = {
        "id": _list.id,
        "token": _user.token,
        "titre": titre.text,
        "description": description.text,
      };
      try {
        var response = await http.put(Uri.parse(url),
            body: json.encode(body),
            headers: {'content-type': 'application/json'});
        final Map<String, dynamic> data = json.decode(response.body);
        Fluttertoast.showToast(
            backgroundColor: Styles.mainColor, msg: data['message']);
      } catch (e) {
        print(e);
        Fluttertoast.showToast(
            backgroundColor:
                Styles.darkMode ? Styles.darkRed : Colors.redAccent,
            msg: "Impossible d'accéder à la base de données.");
      }
    }
  }
}
