import 'package:flutter/material.dart';
import 'app_bar.dart';

//contenu de la page ajouter un poste
class AddPost extends StatelessWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //Size size = MediaQuery.of(context).size;

    return TextButton (
      child: Text("test"),
      style: TextButton.styleFrom(
        primary: Colors.black,
        backgroundColor: Colors.greenAccent,
      ),
      onPressed: () {},
    );
  }
}