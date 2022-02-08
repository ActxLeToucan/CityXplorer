import 'dart:ui';

import 'package:cityxplorer/components/background_image.dart';
import 'package:cityxplorer/components/password_input.dart';
import 'package:cityxplorer/components/text_input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../conf.dart';
import '../styles.dart';

class CreateNewAccount extends StatefulWidget {
  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

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
                      controller: username,
                      icon: Icons.account_circle,
                      hint: 'Pseudo',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                    ),
                    TextInputField(
                      controller: email,
                      icon: Icons.email,
                      hint: 'Email',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                    ),
                    PasswordInput(
                      controller: password,
                      icon: Icons.lock_rounded,
                      hint: 'Password',
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MaterialButton(
                      height: size.height * Styles.heightElementLogin,
                      minWidth: size.width * Styles.widthElementLogin,
                      color: HexColor("22402F"),
                      onPressed: () async {
                        register();
                      },
                      child: const Text(
                        "S'inscrire",
                        style: Styles.textStyleLoginButton,
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
    String url = "http://" + Conf.bddIp + Conf.bddPath + "/register.php";
    var response = await http.post(Uri.parse(url), body: {
      "username": username.text,
      "password": password.text,
      "email": email.text
    });
    print(username.text);

    final Map<String, dynamic> data = json.decode(response.body);
    var res = data['result'];

    if (res == "Error") {
      Fluttertoast.showToast(
          msg: 'User already exit!', fontSize: 25, textColor: Colors.red);
    } else {
      Fluttertoast.showToast(
          msg: 'Registration Successful',
          fontSize: 25,
          textColor: Colors.green);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Conf.stayLogin, username.text);
      Navigator.of(context)
          .pushNamedAndRemoveUntil('main', (Route<dynamic> route) => false);
    }
  }
}
