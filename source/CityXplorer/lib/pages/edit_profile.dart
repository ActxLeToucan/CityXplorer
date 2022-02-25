import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';

import '../components/profile_widget.dart';
import '../components/textfield_widget.dart';

class EditProfilePage extends StatelessWidget {
  final UserConneted user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: transparentAppBar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 15, 32, 0),
        child: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            ProfileWidget(
              user: user,
              isEdit: true,
              onClicked: () async {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Nom',
              text: user.name,
              onChanged: (name) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Pseudo',
              text: user.pseudo,
              onChanged: (email) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Description',
              text: user.description,
              maxLines: 5,
              onChanged: (about) {},
            ),
          ],
        ),
      ),
    );
  }
}
