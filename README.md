S3B
* CONTOUX Antoine
* KEMMLER Lucas
* LOPES VAZ Alexis
* TISSERANT Paul

# CityXplorer
* [Documentation de l'api CityXplorer](https://documenter.getpostman.com/view/18314767/UVkgxyyz)
## Installation du projet
### API
Il faut avoir un serveur apache et configurer le virtualhost.

### Appli mobile
Ajouter le fichier `source/CityXplorer/lib/conf_private.dart` avec la clef d'api Google :
```dart
class ConfPrivate {
  static const String googleApiKey = "GOOGLE_API_KEY";
}
```

Renommer les fichiers :
*  `source/CityXplorer/web/index_exemple.html` en `source/CityXplorer/web/index.html`
*  `source/CityXplorer/android/app/src/main/AndroidManifest_exemple.xml` en `source/CityXplorer/android/app/src/main/AndroidManifest.xml`

et définir la clef d'api Google dans ces fichiers.