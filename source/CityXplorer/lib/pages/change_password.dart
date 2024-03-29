import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../components/appbar.dart';
import '../components/input_field.dart';
import '../conf.dart';
import '../main.dart';
import '../models/user_connected.dart';
import '../router/delegate.dart';
import '../styles.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController newPasswordAgain = TextEditingController();

  UserConnected _user = UserConnected.empty();
  bool _initialized = false;
  bool isLoading = false;

  @override
  void initState() {
    getUser().then((user) {
      setState(() {
        _user = user;
        _initialized = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      if (_user.isEmpty()) {
        return Scaffold(
            backgroundColor: (Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground),
            extendBodyBehindAppBar: true,
            appBar: transparentAppBar(context),
            body: Center(
                child: Text("Connectez-vous pour accéder à cette page",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: (Styles.darkMode
                            ? Styles.darkTextColor
                            : Styles.lightTextColor)))));
      } else {
        return Scaffold(
            backgroundColor: (Styles.darkMode
                ? Styles.darkBackground
                : Styles.lightBackground),
            extendBodyBehindAppBar: true,
            appBar: transparentAppBar(context),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 15, 32, 0),
                child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    InputField(
                      controller: oldPassword,
                      hintText: "Ancien mot de passe",
                      hintPosition: HintPosition.above,
                      withBottomSpace: true,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Saisissez votre ancien mot de passe';
                        }
                        return null;
                      },
                    ),
                    InputField(
                      controller: newPassword,
                      hintText: "Nouveau mot de passe",
                      hintPosition: HintPosition.above,
                      withBottomSpace: true,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Choississez un nouveau mot de passe';
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
                    InputField(
                      controller: newPasswordAgain,
                      hintText: "Confirmation nouveau mot de passe",
                      hintPosition: HintPosition.above,
                      withBottomSpace: true,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value != newPassword.text) {
                          return "Les mots de passe ne correspondent pas";
                        }
                        return null;
                      },
                      onSubmitted: (_) async {
                        setState(() => isLoading = true);
                        await changePass();
                        setState(() => isLoading = false);
                      },
                    ),
                    Button(
                      type: ButtonType.big,
                      text: "Changer le mot de passe",
                      withLoadingAnimation: true,
                      onPressed: changePass,
                      parentState: isLoading,
                    ),
                  ],
                ),
              ),
            ));
      }
    } else {
      return Scaffold(
          backgroundColor: (Styles.darkMode
              ? Styles.darkBackground
              : Styles.lightBackground),
          extendBodyBehindAppBar: true,
          appBar: transparentAppBar(context),
          body: const Center(child: CircularProgressIndicator()));
    }
  }

  Future<void> changePass() async {
    if (_formKey.currentState!.validate()) {
      String url = Conf.domainApi + "/change_password";
      Map<String, dynamic> body = {
        'token': _user.token,
        'oldPassword': oldPassword.text,
        'newPassword': newPassword.text,
      };

      try {
        var response = await http.post(Uri.parse(url),
            body: json.encode(body),
            headers: {'content-type': 'application/json'});
        final Map<String, dynamic> data = json.decode(response.body);

        var res = data['result'];
        if (res == 1) {
          routerDelegate.popRoute();
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
