import 'dart:ui';

import 'package:cityxplorer/components/background-image.dart';
import 'package:cityxplorer/components/password-input.dart';
import 'package:cityxplorer/components/text-field-input.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CreateNewAccount extends StatefulWidget {
  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  Future register() async {
    var url = "http://192.168.1.54/phpFlutterLogin/register.php";
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
      Navigator.pushNamed(context, '/');
    }
  }

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
                            backgroundColor: Colors.grey[400]?.withOpacity(
                              0.4,
                            ),
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
                      hint: 'User',
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
                    SizedBox(
                      height: 25,
                    ),
                    MaterialButton(
                      color: HexColor("22402F"),
                      height: size.height * 0.08,
                      onPressed: () async {
                        register();
                      },
                      child: Text(
                        '                                Register                                ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                              fontSize: 22, color: Colors.white, height: 1.5),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'login');
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    height: 1.5)
                                .copyWith(
                                    color: Color(0xff5663ff),
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
