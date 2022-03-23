import 'dart:convert';

import 'package:cityxplorer/models/user.dart';
import 'package:cityxplorer/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../router/delegate.dart';

//contenu de la page d accueil
class Home extends StatelessWidget {
  bool initialized = false;
  User user = User.empty();

  Home({Key? key, required this.initialized, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Get.find<MyRouterDelegate>();

    return Column(
      children: [
        Container(
          constraints: const BoxConstraints.expand(height: 250),
          child: Image.asset(
            'assets/tour_eiffel.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 30),
        initialized
            ? !user.isEmpty()
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 140.0,
                        height: 60.0,
                        child: TextButton(
                            child: const Text("Profil"),
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                              backgroundColor: Colors.greenAccent,
                            ),
                            onPressed: () {
                              if (!user.isEmpty()) {
                                user.pushPage();
                              }
                            }),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        width: 140.0,
                        height: 60.0,
                        child: TextButton(
                          child: const Text("Mes postes"),
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            backgroundColor: Colors.greenAccent,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  )
                : const SizedBox(
                    width: 350,
                    child: Text(
                      "Connectez-vous ou créez un compte pour profiter pleinement de l'application !",
                      textAlign: TextAlign.center,
                    ),
                  )
            : const CircularProgressIndicator(),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 350,
            decoration: BoxDecoration(
              border: Border.all(width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              "Sauvegardez des photos de lieux qui vous intéressent, partagez-les avec vos amis et consultez les leurs !",
              textAlign: TextAlign.center,
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(fontSizeFactor: 1.2), //pour agrandir le texte
            ),
          ),
        ),
      ],
    );
  }
}
