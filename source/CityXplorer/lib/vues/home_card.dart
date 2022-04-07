import 'package:cityxplorer/components/input_field.dart';
import 'package:cityxplorer/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../conf.dart';
import '../styles.dart';

//contenu de la page d accueil
class Home extends StatelessWidget {
  final bool initialized;
  final User user;

  const Home({Key? key, required this.initialized, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buttonDownload = Container();
    if (kIsWeb && Conf.downloadable.contains(defaultTargetPlatform)) {
      buttonDownload = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Button(
            type: ButtonType.small,
            onPressed: _pageDownload,
            text:
                "Téléchargez CityXplorer sur votre appareil pour profiter au maximum des fonctionnalités de l'application !",
            textAlign: TextAlign.center),
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            "Bienvenue sur CityXplorer !\n Prenez des photos de lieux, partagez les et découvrez celles de vos amis ! ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Questrial',
                              fontSize: 20.0,
                              color: Styles.darkMode
                                  ? Styles.darkTextColor
                                  : Styles.lightTextColor,
                            )),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 140.0,
                            child: Button(
                                type: ButtonType.big,
                                text: 'Profil',
                                fontSize: 17.0,
                                fontFamily: 'Questrial',
                                onPressed: () {
                                  if (!user.isEmpty()) {
                                    user.pushPage();
                                  }
                                }),
                          ),
                          const SizedBox(width: 30),
                          SizedBox(
                              width: 140.0,
                              child: Button(
                                type: ButtonType.big,
                                text: "Mes listes",
                                fontSize: 17.0,
                                fontFamily: 'Questrial',
                                onPressed: () {
                                  if (!user.isEmpty()) {
                                    user.pushPageLists();
                                  }
                                },
                              )),
                        ],
                      ),
                    ],
                  )
                : SizedBox(
                    width: 350,
                    child: Text(
                      "Connectez-vous ou créez un compte pour profiter pleinement de l'application !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Styles.darkMode
                              ? Styles.darkTextColor
                              : Styles.lightTextColor),
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
