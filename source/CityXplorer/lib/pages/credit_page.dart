import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../router/delegate.dart';

class CreditPage extends StatelessWidget {
  final routerDelegate = Get.find<MyRouterDelegate>();

  CreditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => routerDelegate.popRoute(),
          ),
          title: const Text(
            'Crédits',
          ),
        ),
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
                      "L'application a été conçu par les étudiants de deuxième années de DUT Informatique Antoine CONTOUX, Lucas KEMMLER, Alexis LOPES VAZ et Paul TISSERANT dans le cadre de leur projet tutoré en 2021/2022.\n",
                      textAlign: TextAlign.justify),
                  Text(
                      "Nous remercions Madame Isabelle Debled-Renesson et Monsieur Patrick Nourricier de nous avoir suivis pendant toute la  durée du projet 👍.\n",
                      textAlign: TextAlign.justify),
                  Text(
                      "Merci aussi à Monsieur Pierre-André Guénégo pour avoir proposé ce sujet de projet.",
                      textAlign: TextAlign.justify),
                ]),
              ),
              Container(
                child: Image.asset(
                  'assets/logo.png',
                  height: 160,
                  width: 160,
                ),
              ),
            ],
          ),
        ));
  }
}
