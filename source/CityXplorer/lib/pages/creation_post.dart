
import 'package:cityxplorer/components/appbar_default.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class CreationPostScreen extends StatelessWidget {
  final String imagePath;

  const CreationPostScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SingleChildScrollView(
        child: Column(
          children:<Widget>[
            const SizedBox(height: 30),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Ajouter un titre',
              ),
            ),
            const SizedBox(height: 5),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Ajouter la ville',
              ),
            ),
            const SizedBox(height: 5),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Ajouter la date',
              ),
            ),
            const SizedBox(height: 5),
            Container(
              constraints: const BoxConstraints.expand(height: 250),
              child:
              kIsWeb ? Image.network(imagePath) : Image.file(File(imagePath)),
              ),
            const SizedBox(height: 5),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Ajouter une description',
              ),
            ),
            TextButton(
              child: const Text("Créer le post"),
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.greenAccent,
              ),
              onPressed: () {},
            ),
            TextButton(
              child: const Text("Annuler"),
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {Navigator.pop(context);},
            ),
          ]
        ),
      )
    );
  }

}