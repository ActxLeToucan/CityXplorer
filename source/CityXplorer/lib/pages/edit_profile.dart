import 'package:cityxplorer/components/appbar.dart';
import 'package:cityxplorer/components/input_field.dart';
import 'package:cityxplorer/main.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/material.dart';

import '../components/profile_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  UserConneted _user = UserConneted.empty();
  bool _initialized = false;

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
    TextEditingController name = TextEditingController(text: _user.name);
    TextEditingController description =
        TextEditingController(text: _user.description);
    if (_initialized) {
      if (_user.isEmpty()) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: transparentAppBar(context),
            body: const Center(child: Text("Utilisateur invalide.")));
      } else {
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
                  user: _user,
                  isEdit: true,
                  onClicked: () async {},
                ),
                const SizedBox(height: 24),
                InputField(
                    controller: name,
                    hintText: "Nom",
                    hintPosition: HintPosition.above,
                    withBottomSpace: true),
                InputField(
                    controller: description,
                    hintText: "Description",
                    hintPosition: HintPosition.above,
                    minLines: 2,
                    maxLines: 5),
              ],
            ),
          ),
        );
      }
    } else {
      return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: transparentAppBar(context),
          body: const Center(child: CircularProgressIndicator()));
    }
  }
}
