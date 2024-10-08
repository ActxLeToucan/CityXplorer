import 'dart:convert';

import 'package:cityxplorer/components/background_image.dart';
import 'package:cityxplorer/components/input_field.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../router/delegate.dart';
import '../styles.dart';

class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({Key? key}) : super(key: key);

  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController pseudo = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordAgain = TextEditingController();
  final TextEditingController name = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(image: AssetImage('assets/forest.jpg')),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Center(child: _renderTitle()),
                  Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            InputLogin(
                              controller: pseudo,
                              hintText: 'Pseudo',
                              icon: Icons.account_circle,
                              inputAction: TextInputAction.next,
                              withBottomSpace: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Entrez un pseudo';
                                }
                                if (value.length < Conf.taillePseudoMin) {
                                  return "Ce pseudo est trop court";
                                }
                                if (value.length > Conf.taillePseudoMax) {
                                  return "Ce pseudo est trop long";
                                }
                                if (!Conf.regexPseudo.hasMatch(value)) {
                                  return "Ce pseudo est invalide";
                                }
                                return null;
                              },
                            ),
                            InputLogin(
                              controller: name,
                              icon: Icons.accessibility_new,
                              hintText: 'Nom',
                              inputAction: TextInputAction.next,
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
                            InputLogin(
                              controller: password,
                              icon: Icons.lock_rounded,
                              hintText: 'Mot de passe',
                              inputAction: TextInputAction.next,
                              withBottomSpace: true,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Choississez un mot de passe';
                                }
                                if (value.length < Conf.tailleMdpMin) {
                                  return "Ce mot de passe est trop court";
                                }
                                if (value.length > Conf.tailleMdpMax) {
                                  return "Ce mot de passe est trop long";
                                }
                                return null;
                              },
                            ),
                            InputLogin(
                              controller: passwordAgain,
                              icon: Icons.lock_rounded,
                              hintText: 'Confirmation mot de passe',
                              inputAction: TextInputAction.done,
                              withBottomSpace: true,
                              isPassword: true,
                              onSubmitted: (_) async {
                                setState(() => isLoading = true);
                                await register();
                                setState(() => isLoading = false);
                              },
                              validator: (value) {
                                if (value != password.text) {
                                  return "Les mots de passe ne correspondent pas";
                                }
                                return null;
                              },
                            ),
                            ButtonLogin(
                              type: ButtonType.big,
                              text: "S'inscrire",
                              onPressed: register,
                              parentState: isLoading,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            ButtonLogin(
                                type: ButtonType.small,
                                text: "Se connecter",
                                onPressed: () => routerDelegate
                                    .pushPageAndClear(name: '/login')),
                            ButtonLogin(
                                type: ButtonType.small,
                                text: "Continuer sans compte",
                                onPressed: () =>
                                    routerDelegate.pushPageAndClear(name: '/')),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future register() async {
    if (_formKey.currentState!.validate()) {
      String url = Conf.domainApi + "/register";
      Map<String, dynamic> body = {
        "pseudo": pseudo.text,
        "password": password.text,
        "name": name.text
      };

      try {
        var response = await http.post(Uri.parse(url),
            body: json.encode(body),
            headers: {'content-type': 'application/json'});
        final Map<String, dynamic> data = json.decode(response.body);
        var res = data['result'];

        if (res == 1) {
          UserConnected user = UserConnected.fromJson(data['user']);
          connexion(user);

          routerDelegate.pushPageAndClear(name: '/');
        }
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

  Widget _renderTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 0),
      child: const Text(
        'CityXplorer',
        style: TextStyle(
            color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
      ),
    );
  }
}
