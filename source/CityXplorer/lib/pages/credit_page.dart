import 'package:cityxplorer/components/appbar.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class CreditPage extends StatelessWidget {
  const CreditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Styles.darkMode ? Styles.darkBackground : Styles.lightBackground,
        appBar: namedAppBar(context, "Crédits"),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/CityXplorer.gif",
                height: 100.0,
                width: 300.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                child: Column(children: [
                  Text(
                      "L'application a été conçu par les étudiants de deuxième année de DUT Informatique Antoine CONTOUX, Lucas KEMMLER, Alexis LOPES VAZ et Paul TISSERANT dans le cadre de leur projet tutoré en 2021/2022.\n",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: (Styles.darkMode
                              ? Styles.darkTextColor
                              : Styles.lightTextColor))),
                  Text(
                      "Nous remercions Madame Isabelle Debled-Renesson et Monsieur Patrick Nourricier de nous avoir suivis pendant toute la  durée du projet 👍.\n",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: (Styles.darkMode
                              ? Styles.darkTextColor
                              : Styles.lightTextColor))),
                  Text(
                      "Merci aussi à Monsieur Pierre-André Guénégo pour avoir proposé ce sujet de projet.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: (Styles.darkMode
                              ? Styles.darkTextColor
                              : Styles.lightTextColor))),
                ]),
              ),
              Image.asset(
                'assets/logo.png',
                height: 160,
                width: 160,
              ),
            ],
          ),
        ));
  }
}
