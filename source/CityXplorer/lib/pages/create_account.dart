import 'dart:convert';
import 'dart:ui';

import 'package:cityxplorer/components/background_image.dart';
import 'package:cityxplorer/components/password_input.dart';
import 'package:cityxplorer/components/text_input_field.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../conf.dart';
import '../styles.dart';

class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({Key? key}) : super(key: key);

  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  TextEditingController pseudo = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(image: AssetImage('assets/forest.jpg')),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.width * 0.1,
                ),
                Stack(
                  children: [
                    Center(
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: CircleAvatar(
                            radius: size.width * 0.14,
                            backgroundColor: Styles.backgroundColorInput,
                            child: Icon(
                              Icons.account_box_outlined,
                              color: Colors.white,
                              size: size.width * 0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                Column(
                  children: [
                    TextInputField(
                      controller: pseudo,
                      icon: Icons.account_circle,
                      hint: 'Pseudo',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                    ),
                    TextInputField(
                      controller: name,
                      icon: Icons.accessibility_new,
                      hint: 'Nom',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                    ),
                    PasswordInput(
                      controller: password,
                      icon: Icons.lock_rounded,
                      hint: 'Password',
                      inputAction: TextInputAction.next,
                      onSubmitted: (_) => register(),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    IgnorePointer(
                      ignoring: isLoading ? true : false,
                      child: MaterialButton(
                        height: size.height * Styles.heightElementLogin,
                        minWidth: size.width * Styles.widthElementLogin,
                        color: HexColor("22402F"),
                        onPressed: () async {
                          register();
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
                                "S'inscrire",
                                style: Styles.textStyleLoginButton,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushReplacementNamed('login'),
                      child: Container(
                        child: const Text(
                            'Vous avez déjà un compte ?\nConnectez-vous.',
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
        )
      ],
    );
  }

  Future register() async {
    setState(() {
      isLoading = true;
    });

    String url = Conf.bddDomainUrl + Conf.bddPath + "/register";

    try {
      var response = await http.post(Uri.parse(url), body: {
        "pseudo": pseudo.text,
        "password": password.text,
        "name": name.text
      });
      final Map<String, dynamic> data = json.decode(response.body);
      var res = data['result'];

      if (res == 1) {
        UserConneted user = UserConneted.fromJson(data['user']);
        connexion(user);

        Navigator.of(context)
            .pushNamedAndRemoveUntil('main', (Route<dynamic> route) => false);
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
