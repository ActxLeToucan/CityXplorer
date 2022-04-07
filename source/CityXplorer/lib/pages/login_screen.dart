import 'dart:convert';

import 'package:cityxplorer/components/background_image.dart';
import 'package:cityxplorer/components/input_field.dart';
import 'package:cityxplorer/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../models/user_connected.dart';
import '../router/delegate.dart';
import '../styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController pseudo = TextEditingController();
  final TextEditingController password = TextEditingController();

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
                              icon: Icons.account_circle,
                              hintText: 'Pseudo',
                              inputAction: TextInputAction.next,
                              withBottomSpace: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrez votre mot de passe';
                                }
                                return null;
                              },
                            ),
                            InputLogin(
                              controller: password,
                              icon: Icons.lock_rounded,
                              hintText: 'Mot de passe',
                              inputAction: TextInputAction.done,
                              withBottomSpace: true,
                              isPassword: true,
                              onSubmitted: (_) async {
                                setState(() => isLoading = true);
                                await login();
                                setState(() => isLoading = false);
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Entrez votre pseudo';
                                }
                                return null;
                              },
                            ),
                            ButtonLogin(
                              type: ButtonType.big,
                              text: "Se connecter",
                              onPressed: login,
                              parentState: isLoading,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            ButtonLogin(
                                type: ButtonType.small,
                                text: "Créer un compte",
                                onPressed: () => routerDelegate
                                    .pushPageAndClear(name: '/signup')),
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
        ),
      ],
    );
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

  Future login() async {
    if (_formKey.currentState!.validate()) {
      String url = Conf.domainServer + Conf.apiPath + "/login";
      Map<String, dynamic> body = {
        'pseudo': pseudo.text,
        'password': password.text,
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
}
