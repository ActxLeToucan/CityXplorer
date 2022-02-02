import 'package:cityxplorer/components/background-image.dart';
import 'package:cityxplorer/components/password-input.dart';
import 'package:cityxplorer/components/text-field-input.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  Future login() async {
    var url = "http://192.168.1.54/phpFlutterLogin/login.php";

    var response = await http.post(Uri.parse(url), body: {
      'username': username.text,
      'password': password.text,
    });

    //var data = response.body.toString().replaceAll("\n","");
    final Map<String, dynamic> data = json.decode(response.body);
    var res = data['result'];

    print(res);

    if (res == '1') {
      Fluttertoast.showToast(
          msg: 'Login Successful', fontSize: 25, textColor: Colors.green);
      Navigator.pushNamed(context, '/');
    } else {
      Fluttertoast.showToast(
          msg: 'Username or password invalid',
          fontSize: 25,
          textColor: Colors.red);
    }
  }

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
          body: Column(
            children: [
              Flexible(
                child: Center(
                  child: Text(
                    'CityXplorer',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextInputField(
                    controller: username,
                    icon: Icons.account_circle,
                    hint: 'User',
                    inputType: TextInputType.name,
                    inputAction: TextInputAction.next,
                  ),
                  PasswordInput(
                    controller: password,
                    icon: Icons.lock_rounded,
                    hint: 'Password',
                    inputAction: TextInputAction.done,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  //RoundedButton(buttonName: 'Login now', methode: login )
                  MaterialButton(
                    height: size.height * 0.07,
                    color: HexColor("22402F"),
                    onPressed: () async {
                      login();
                    },
                    child: Text(
                      '                                  Login Now                                ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'newAccount'),
                child: Container(
                  child: Text(
                    'Create New Account',
                    style: TextStyle(
                        fontSize: 22, color: Colors.white, height: 1.5),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.white))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }
}
