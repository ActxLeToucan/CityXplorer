S3B
* CONTOUX Antoine
* KEMMLER Lucas
* LOPES VAZ Alexis
* TISSERANT Paul

# CityXplorer
* [Documentation de l'api CityXplorer](https://documenter.getpostman.com/view/18314767/UVkgxyyz)
## Installation du projet
### Base de données
Importez la base de données à partir du fichier [cityxplorer.sql](source/APIBDD/SQL/cityxplorer.sql).

### API
Il faut avoir un serveur apache et configurer le virtualhost.

Renommez et modifiez les fichiers avec votre configuration :
* [`source/APIBDD/src/conf/Conf_example.php`](source/APIBDD/src/conf/Conf_example.php) en `source/APIBDD/src/conf/Conf.php`
* [`source/APIBDD/src/conf/db_example.ini`](source/APIBDD/src/conf/db_example.ini) en `source/APIBDD/src/conf/db.ini`

### Appli mobile
Ajoutez le fichier `source/CityXplorer/lib/conf_private.dart` avec la clef d'api Google :
```dart
class ConfPrivate {
  static const String googleApiKey = "GOOGLE_API_KEY";
}
```

Renommez les fichiers :
*  [`source/CityXplorer/web/index_exemple.html`](source/CityXplorer/web/index_exemple.html) en `source/CityXplorer/web/index.html`
*  [`source/CityXplorer/android/app/src/main/AndroidManifest_exemple.xml`](source/CityXplorer/android/app/src/main/AndroidManifest_exemple.xml) en `source/CityXplorer/android/app/src/main/AndroidManifest.xml`

et définissez la clef d'api Google dans ces fichiers.
