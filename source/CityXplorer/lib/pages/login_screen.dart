import 'dart:convert';

import 'package:cityxplorer/components/background_image.dart';
import 'package:cityxplorer/components/password_input.dart';
import 'package:cityxplorer/components/text_input_field.dart';
import 'package:cityxplorer/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
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

  TextEditingController pseudo = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  Column(
                    children: [
                      TextInputField(
                        controller: pseudo,
                        icon: Icons.account_circle,
                        hint: 'Pseudo',
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                      ),
                      PasswordInput(
                        controller: password,
                        icon: Icons.lock_rounded,
                        hint: 'Mot de passe',
                        inputAction: TextInputAction.done,
                        onSubmitted: (_) => login(),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      IgnorePointer(
                        /// rend le bouton non cliquable si il est en train d envoyer la requete
                        ignoring: isLoading ? true : false,
                        child: MaterialButton(
                          height: size.height * Styles.heightElementLogin,
                          minWidth: size.width * Styles.widthElementLogin,
                          color: HexColor("22402F"),
                          onPressed: () async {
                            login();
                          },
                          child: (isLoading)
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: Colors.white,
                                  ))
                              : const Text(
                                  'Se connecter',
                                  style: Styles.textStyleLoginButton,
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextButton(
                        onPressed: () =>
                            routerDelegate.pushPageAndClear(name: '/signup'),
                        child: Container(
                          child: const Text('Créer un compte',
                              style: Styles.textStyleInput,
                              textAlign: TextAlign.center),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Styles.loginTextColor))),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            routerDelegate.pushPageAndClear(name: '/'),
                        child: Container(
                          child: const Text('Continuer sans se connecter',
                              style: Styles.textStyleInput,
                              textAlign: TextAlign.center),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Styles.loginTextColor))),
                        ),
                      ),
                    ],
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
    setState(() {
      isLoading = true;
    });

    String url = Conf.domainServer + Conf.apiPath + "/login";

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

    setState(() {
      isLoading = false;
    });
  }
}
