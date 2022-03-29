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

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final routerDelegate = Get.find<MyRouterDelegate>();

  final TextEditingController pseudo = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ButtonLogin buttonLogin = ButtonLogin(
        type: ButtonType.big, text: "Se connecter", onPressed: login);
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        InputLogin(
                          controller: pseudo,
                          icon: Icons.account_circle,
                          hintText: 'Pseudo',
                          inputAction: TextInputAction.next,
                          withBottomSpace: true,
                        ),
                        InputLogin(
                            controller: password,
                            icon: Icons.lock_rounded,
                            hintText: 'Mot de passe',
                            inputAction: TextInputAction.done,
                            withBottomSpace: true,
                            isPassword: true,
                            onSubmitted: (_) {
                              //TODO
                            }),
                        buttonLogin,
                        const SizedBox(
                          height: 50,
                        ),
                        ButtonLogin(
                            type: ButtonType.small,
                            text: "Créer un compte",
                            onPressed: () => routerDelegate.pushPageAndClear(
                                name: '/signup')),
                        ButtonLogin(
                            type: ButtonType.small,
                            text: "Continuer sans compte",
                            onPressed: () =>
                                routerDelegate.pushPageAndClear(name: '/')),
                      ],
                    ),
                  ),
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
    String url = Conf.domainServer + Conf.apiPath + "/login";
    await Future.delayed(const Duration(seconds: 2), () {});
    try {
      var response = await http.post(Uri.parse(url), body: {
        'pseudo': pseudo.text,
        'password': password.text,
      });
      final Map<String, dynamic> data = json.decode(response.body);
      var res = data['result'];

      if (res == 1) {
        UserConneted user = UserConneted.fromJson(data['user']);
        connexion(user);

        routerDelegate.pushPageAndClear(name: '/');
      }
      Fluttertoast.showToast(msg: data['message']);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }
  }
}
