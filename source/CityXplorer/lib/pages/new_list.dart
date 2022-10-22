import 'dart:convert';

import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/components/input_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../main.dart';
import '../models/user_connected.dart';
import '../router/delegate.dart';
import '../styles.dart';

/// formulaire de creation d'un post avec gestion de la requete envoyee et de son resultat
class NewListScreen extends StatefulWidget {
  const NewListScreen({Key? key}) : super(key: key);

  @override
  State<NewListScreen> createState() => _NewListScreenState();
}

class _NewListScreenState extends State<NewListScreen> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  final _formKey = GlobalKey<FormState>();
  final controllerTitre = TextEditingController(text: "Sans titre");
  final controllerDescription = TextEditingController();
  bool _initialized = false;
  UserConnected _user = UserConnected.empty();

  @override
  void initState() {
    getUser().then((u) {
      setState(() {
        _user = u;
        _initialized = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return Scaffold(
        backgroundColor:
            Styles.darkMode ? Styles.darkBackground : Styles.lightBackground,
        appBar: namedAppBar(context, "Créer une liste"),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
              child: Column(
                children: [
                  InputField(
                    controller: controllerTitre,
                    hintText: "Titre de la liste",
                    hintPosition: HintPosition.swap,
                    withBottomSpace: true,
                    autoFocus: true,
                    inputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Remplissez ce champ pour continuer';
                      }
                      return null;
                    },
                  ),
                  InputField(
                    controller: controllerDescription,
                    hintText: "Description de la liste",
                    hintPosition: HintPosition.swap,
                    minLines: 2,
                    maxLines: 5,
                    withBottomSpace: true,
                  ),
                  Button(
                    type: ButtonType.big,
                    text: "Valider",
                    withLoadingAnimation: true,
                    onPressed: envoyerLaList,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
          backgroundColor:
              Styles.darkMode ? Styles.darkBackground : Styles.lightBackground,
          appBar: defaultAppBar(context),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  /// renvoie la date du jour au format JJ/MM/AAAA -- affichage utilisateur

  /// methode appelee lors de la creation de la list dans la BDD
  Future<void> envoyerLaList() async {
    if (_formKey.currentState!.validate()) {
      String url = Conf.domainApi + "/list";
      Map<String, dynamic> body = {
        "token": _user.token,
        "titre": controllerTitre.text,
        "desc": controllerDescription.text.trim(),
      };

      try {
        var response = await http.post(Uri.parse(url),
            body: json.encode(body),
            headers: {'content-type': 'application/json'});
        final Map<String, dynamic> data = json.decode(response.body);

        Fluttertoast.showToast(
            backgroundColor: Styles.mainColor, msg: data['message']);

        if (data['result'] == 1) {
          routerDelegate.popRoute();
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
}
