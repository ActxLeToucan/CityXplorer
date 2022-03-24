import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cityxplorer/components/custom_alert_post.dart';
import 'package:cityxplorer/models/user_connected.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../conf.dart';
import '../main.dart';
import '../router/delegate.dart';
import '../styles.dart';

/// formulaire de creation d'un post avec gestion de la requete envoyee et de son resultat
class NewPostScreen extends StatefulWidget {
  final Map<String, String> arguments;

  const NewPostScreen({Key? key, required this.arguments}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final routerDelegate = Get.find<MyRouterDelegate>();

  final _formKey = GlobalKey<FormState>();
  final controllerTitre = TextEditingController();
  final controllerDescription = TextEditingController();
  DateTime now = DateTime.now();
  bool isLoading = false;
  List photos = [];

  String imagePath = "";
  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    super.initState();
    imagePath = widget.arguments['imagePath'] ?? "";
    latitude = double.parse(widget.arguments['latitude'] ?? "0.0");
    longitude = double.parse(widget.arguments['longitude'] ?? "0.0");
  }

  @override
  Widget build(BuildContext context) {
    if (imagePath != "") {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => routerDelegate.popRoute(),
          ),
          title: const Text(
            'Créer un post',
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    controller: controllerTitre,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Styles.mainColor, width: 2.5),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Styles.mainColor, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      border: OutlineInputBorder(),
                      helperText: "Obligatoire",
                      hintText: 'Ajouter un titre',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Remplissez ce champ pour continuer ';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  constraints: const BoxConstraints.expand(height: 250),
                  child: kIsWeb
                      ? Image.network(imagePath)
                      : Image.file(File(imagePath)),
                ),
                const SizedBox(height: 5),
                Text("Prise le : " + getCurrentDate(),
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    controller: controllerDescription,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Styles.mainColor, width: 2.5),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Styles.mainColor, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      helperText: "Optionnel",
                      border: OutlineInputBorder(),
                      hintText: 'Ajouter une description',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: IgnorePointer(
                      /// rend le bouton non cliquable si il est en train d envoyer la requete
                      ignoring: isLoading ? true : false,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              await postLePost();
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              Fluttertoast.showToast(msg: '$e');
                            }
                          }
                        },
                        child: (isLoading)
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: Colors.white,
                                ))
                            : const Text('Valider',
                                style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ),
                /**
                    carouselBuild(),
                    ElevatedButton(
                    onPressed: () {},
                    child: Text('NOUVELLE PHOTO', style: TextStyle(fontSize: 20)),

                    ),**/
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => routerDelegate.popRoute(),
            ),
            title: const Text(
              'Créer un post',
            ),
          ),
          body: const Center(child: Text("Photo invalide.")));
    }
  }

  /// renvoie la date du jour au format JJ/MM/AAAA -- affichage utilisateur
  String getCurrentDate() {
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);

    var formattedDate =
        "${dateParse.day.toString().padLeft(2, '0')}/${dateParse.month.toString().padLeft(2, '0')}/${dateParse.year}";
    return formattedDate.toString();
  }

  /// renvoie la date du jour au format YYY-MM-DD hh:mm:ss -- pour la BDD
  String getCurrentDateBDD() {
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);

    var formattedDate =
        "${dateParse.year}-${dateParse.month.toString().padLeft(2, '0')}-${dateParse.day.toString().padLeft(2, '0')} ${dateParse.hour.toString().padLeft(2, '0')}:${dateParse.minute.toString().padLeft(2, '0')}:${dateParse.second.toString().padLeft(2, '0')}";
    return formattedDate.toString();
  }

  /// methode appelee lors de la creation du post dans la BDD
  Future postLePost() async {
    String url = Conf.domainServer + Conf.apiPath + "/post";

    var request = http.MultipartRequest("POST", Uri.parse(url));
    try {
      request.fields['titre'] = controllerTitre.text;
      request.fields['description'] = controllerDescription.text;

      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();

      request.fields['date'] = getCurrentDateBDD();

      UserConneted user = await getUser();
      if (!user.isEmpty()) {
        request.fields['token'] = user.token;
      } else {
        throw Exception('Erreur : session !');
      }

      List adresses = await getAdresse();
      request.fields['adresse-longue'] = adresses[0] ?? "";
      request.fields['adresse-courte'] = adresses[1] ?? "";

      ///ajout de la photo a la requete
      request.files.add(await http.MultipartFile.fromPath("photo", imagePath,
          contentType: MediaType("image", "jpeg")));

      var response = await http.Response.fromStream(await request.send());
      // print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);
      String res = data['message'];
      int code = data['result'];

      /// si l 'insertion a reussie on retourne sur la page de l'appareil photo
      /// sinon on reste sur le formulaire, peut etre que le gars va resoudre le probleme tout seul
      if (code == 1) {
        routerDelegate.popRoute();
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AdvanceCustomAlert(
              message: res,
              code: code,
            );
          });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List> getAdresse() async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Conf.googleApiKey}&result_type=street_address|locality';

    List<String> adresses = [];

    try {
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      final Map<String, dynamic> data = json.decode(response.body);

      if (data["status"] == "OK") {
        if (data["results"].length > 0) {
          Map firstResult = data["results"][0];
          Map secondResult = data["results"][1];
          String streetAddress = firstResult["formatted_address"];
          String city = secondResult["formatted_address"];

          adresses.add(streetAddress);
          adresses.add(city);
        }
      }
      return adresses;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
      return adresses;
    }
  }

  /// inutilisee pour le moment
  Widget carouselBuild() {
    photos.add(imagePath);
    return CarouselSlider(
      items: photos.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network(photos[i]));
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 400,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
