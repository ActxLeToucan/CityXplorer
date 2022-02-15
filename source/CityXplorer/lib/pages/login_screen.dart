import 'package:cityxplorer/components/background_image.dart';
import 'package:cityxplorer/components/password_input.dart';
import 'package:cityxplorer/components/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../conf.dart';
import '../styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(
          image: AssetImage('assets/forest.jpg'),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(child: _renderTitle()),
                Column(
                  children: [
                    TextInputField(
                      controller: username,
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
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MaterialButton(
                      height: size.height * Styles.heightElementLogin,
                      minWidth: size.width * Styles.widthElementLogin,
                      color: HexColor("22402F"),
                      onPressed: () async {
                        login();
                      },
                      child: const Text(
                        'Se connecter',
                        style: Styles.textStyleLoginButton,
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed('newAccount'),
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
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 0),
      child: const Text(
        'CityXplorer',
        style: TextStyle(
            color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future login() async {
    String url = "http://" + Conf.bddIp + Conf.bddPath + "/login";

    try {
      var response = await http.post(Uri.parse(url), body: {
        'username': username.text,
        'password': password.text,
      });
      final Map<String, dynamic> data = json.decode(response.body);
      var res = data['result'];

      if (res == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(Conf.stayLogin, data['user']['pseudo']);
        prefs.setString("email", data['user']['email']);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('main', (Route<dynamic> route) => false);
      }
      Fluttertoast.showToast(msg: data['message']);
    } catch (e) {
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
    }
  }
}
