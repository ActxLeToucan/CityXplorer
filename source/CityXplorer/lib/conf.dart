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
      "https://github.com/univ-lorraine-iut-charlemagne/S3B_S15_CONTOUX_KEMMLER_TISSERANT_LOPES-VAZ/releases";
  static const List downloadable = [TargetPlatform.android];
}
