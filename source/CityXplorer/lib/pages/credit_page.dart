import 'package:cityxplorer/components/appbar.dart';
import 'package:flutter/material.dart';

class CreditPage extends StatelessWidget {
  CreditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: namedAppBar(context, "Crédits"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/CityXplorer.gif",
                height: 100.0,
                width: 300.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                child: Column(children: const [
                  Text(
                      "L'application a été conçu par les étudiants de deuxième année de DUT Informatique Antoine CONTOUX, Lucas KEMMLER, Alexis LOPES VAZ et Paul TISSERANT dans le cadre de leur projet tutoré en 2021/2022.\n",
                      textAlign: TextAlign.justify),
                  Text(
                      "Nous remercions Madame Isabelle Debled-Renesson et Monsieur Patrick Nourricier de nous avoir suivis pendant toute la  durée du projet 👍.\n",
                      textAlign: TextAlign.justify),
                  Text(
                      "Merci aussi à Monsieur Pierre-André Guénégo pour avoir proposé ce sujet de projet.",
                      textAlign: TextAlign.justify),
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
