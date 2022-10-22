import 'package:cityxplorer/conf_private.dart';
import 'package:flutter/material.dart';

class Conf {
  static const String domainServer = "https://cityxplorer.antoinectx.fr";
  static const String domainApi = "https://cityxplorer.api.antoinectx.fr";
  static const String googleApiKey = ConfPrivate.googleApiKey;
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

  // camera
  static const int maxPhotos = 5;
}
