import 'dart:convert';

import 'package:cityxplorer/models/user.dart';
import 'package:cityxplorer/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//contenu de la page d accueil
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Row(
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
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var userString = prefs.getString('user');
                    User user = User.empty();
                    if (userString != null) {
                      user = User.fromJson(jsonDecode(userString));
                    }
                    if (!user.isEmpty()) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserProfile(user: user)));
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
        ),
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
