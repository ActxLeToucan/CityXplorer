import 'package:flutter/material.dart';

class Conf {
  // TODO utiliser la version publique de l'api
  // uniquement pour le développement, laisser à false sinon
  static const bool _apiDev = false;

  static const String domainServer = "https://cityxplorer.streamlor.io";
  static const String apiPath = _apiDev ? apiDevPath : "/api";
  static const String apiDevPath = "/api-dev";
  static const String googleApiKey = "AIzaSyCoZ5pkSaTZk3rpiGrm3yuTIj48y7NdncU";
  static const String downloadRelease =
      "$domainServer/download/cityxplorer.apk";
  static const List downloadable = [TargetPlatform.android];

  // inputs rules
  static const int taillePseudoMin = 4;
  static const int taillePseudoMax = 50;
  static final RegExp regexPseudo = RegExp(r'^[\w\-]*$');
  static const int tailleNameMin = 4;
  static const int tailleNameMax = 50;
  static const int tailleMdpMin = 8;
  static const int tailleMdpMax = 256;
  static const int tailleTitreMax = 100;
}
