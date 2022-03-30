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

class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({Key? key}) : super(key: key);

  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  final TextEditingController pseudo = TextEditingController();
  final TextEditingController password = TextEditingController();
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        InputLogin(
                          controller: pseudo,
                          hintText: 'Pseudo',
                          icon: Icons.account_circle,
                          inputAction: TextInputAction.next,
                          withBottomSpace: true,
                        ),
                        InputLogin(
                          controller: name,
                          icon: Icons.accessibility_new,
                          hintText: 'Nom',
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
                            onSubmitted: (_) async {
                              setState(() => isLoading = true);
                              await register();
                              setState(() => isLoading = false);
                            }),
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
                            onPressed: () => routerDelegate.pushPageAndClear(
                                name: '/login')),
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
        )
      ],
    );
  }

  Future register() async {
    String url = Conf.domainServer + Conf.apiPath + "/register";
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
