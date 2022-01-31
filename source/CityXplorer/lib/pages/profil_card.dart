import 'package:cityxplorer/components/appbar_default.dart';
import 'package:flutter/material.dart';
import '../post.dart';

// contenu de la page profil de l utilisateur
class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(context),
      body: Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          children: [
            Text(
              'Votre profil 😎',
              textAlign: TextAlign.center,
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2),
            ),
            const SizedBox(height: 16),
            Container(
              height: 470,
              color: Colors.transparent,
              child: ListView(scrollDirection: Axis.vertical, children: [
                Post(),
                Post(),
                Post(),
                Post(),
                Post(),
                Post(),
                Post(),
                Post(),
                Post(),
                Post()
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
