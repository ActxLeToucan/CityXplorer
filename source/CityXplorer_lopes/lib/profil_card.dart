import 'package:flutter/material.dart';
import 'post.dart';

// contenu de la page profil de l utilisateur
class UserProfil extends StatelessWidget {
  const UserProfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //return ListView(
      //scrollDirection: Axis.vertical,
    //);
  return Padding(
    padding: const EdgeInsets.only(top: 12,),
    child: Container(//le contenainer qui contient le poste
        constraints: const BoxConstraints.expand(
          width: 350,
          height: 300,
        ),
        decoration: BoxDecoration(color: Colors.lightBlueAccent),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 30,),
                Text(//le nom du poste
                  'Statue Blandan',
                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      const snackBar = SnackBar(content: Text('afficher un mini menu qui fait des trucs'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    icon: const Icon(Icons.more_vert),
                )
              ],
            ),
            Container(//la photo du poste
              constraints: const BoxConstraints.expand(
                width: 300,
                height: 150,
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/antoine.jpg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(//le nom du poste
                "Une statut d'un grand homme sur la place Blandan" ,
                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2),
              ),
            ),

          ],
        )
      ),
  );
  }
}