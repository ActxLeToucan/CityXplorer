import 'package:cityxplorer/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../conf.dart';

//contenu de la page d accueil
class Home extends StatelessWidget {
  bool initialized = false;
  User user = User.empty();

  Home({Key? key, required this.initialized, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buttonDownload = Container();
    if (kIsWeb && Conf.downloadable.contains(defaultTargetPlatform)) {
      buttonDownload = Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
            onPressed: _pageDownload,
            child: const Text(
                "Téléchargez CityXplorer sur votre appareil pour profiter au maximum des fonctionnalités de l'application !",
                textAlign: TextAlign.center)),
      );
    }

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
        initialized
            ? !user.isEmpty()
                ? Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                            "Bienvenue sur CityXplorer !\n Prenez des photos de lieux, partagez les et découvrez celles de vos amis ! ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Questrial',
                              fontSize: 20.0,
                            )),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 140.0,
                            height: 60.0,
                            child: TextButton(
                                child: const Text("Profil",
                                    style: TextStyle(
                                      fontFamily: 'Questrial',
                                      fontSize: 17.0,
                                    )),
                                style: TextButton.styleFrom(
                                  primary: Colors.black,
                                  backgroundColor: Colors.lightGreen,
                                ),
                                onPressed: () {
                                  if (!user.isEmpty()) {
                                    user.pushPage();
                                  }
                                }),
                          ),
                          const SizedBox(width: 30),
                          SizedBox(
                            width: 140.0,
                            height: 60.0,
                            child: TextButton(
                              child: const Text("Mes listes",
                                  style: TextStyle(
                                    fontFamily: 'Questrial',
                                    fontSize: 17.0,
                                  )),
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                                backgroundColor: Colors.lightGreen,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(
                    width: 350,
                    child: Text(
                      "Connectez-vous ou créez un compte pour profiter pleinement de l'application !",
                      textAlign: TextAlign.center,
                    ),
                  )
            : const CircularProgressIndicator(),
        buttonDownload
      ],
    );
  }

  Future<void> _pageDownload() async {
    var url = Conf.downloadRelease;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
