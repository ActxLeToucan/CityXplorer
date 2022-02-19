import 'package:cityxplorer/components/appbar_default.dart';
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
      appBar: buildDefaultAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
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
            label: 'À propos',
            //text: user.about,
            text:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ac ex ullamcorper, iaculis nisl id, maximus augue. Morbi condimentum dui tellus, quis fermentum ante interdum eget. Proin et turpis leo. Praesent ac quam malesuada, sollicitudin eros vulputate, pharetra ligula. Vestibulum pellentesque ligula euismod nulla elementum lobortis. Suspendisse eget dictum nibh.",
            maxLines: 5,
            onChanged: (about) {},
          ),
        ],
      ),
    );
  }
}
