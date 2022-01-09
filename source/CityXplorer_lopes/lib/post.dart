import 'package:flutter/material.dart';
import 'share_bar_icon.dart';

// classe correspondant a la vue d un poste de l utilisateur
class Post extends StatelessWidget{
  const Post({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12,),
      child: Container(//le contenainer qui contient le poste
          constraints: const BoxConstraints.expand(
            width: 350,
            height: 310,
          ),
          decoration: BoxDecoration(color: Colors.blueGrey),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 100,),
                  Text(//le nom du poste
                    'Statue Blandan',
                    style : TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
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
              Text(//le nom du poste
                'Nancy, le 08/01/2022',
              ),
              Container(//la photo du poste
                constraints: const BoxConstraints.expand(
                  width: 300,
                  height: 150,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/statue_blandan.jpg'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(//le nom du poste
                  "Une statut d'un grand homme sur la place Blandan" ,
                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
                ),
              ),
              ShareBar(),
            ],
          )
      ),
    );
  }
}