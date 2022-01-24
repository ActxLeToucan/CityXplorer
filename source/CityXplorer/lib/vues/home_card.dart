import 'package:flutter/material.dart';

//contenu de la page d accueil
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints.expand(height: 250),
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
                child: Text("Profil"),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.greenAccent,
                ),
                onPressed: () {},
              ),
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
              borderRadius: BorderRadius.all(Radius.circular(10)),
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
