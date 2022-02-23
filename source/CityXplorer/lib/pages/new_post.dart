import 'dart:convert';

import 'package:cityxplorer/models/user_connected.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../styles.dart';

import 'package:http/http.dart' as http;

import '../conf.dart';

import 'package:http_parser/http_parser.dart';
import 'package:cityxplorer/components/AdvanceCustomAlert.dart';

/// formulaire de creation d'un post avec gestion de la requete envoyee et de son resultat
class NewPostScreen extends StatefulWidget {
  final String imagePath;

  const NewPostScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final controllerTitre = TextEditingController();
  final controllerDescription = TextEditingController();
  String latitude = '0';
  String longitude = '0';
  DateTime now = DateTime.now();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
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
                  autofocus: true,
                  decoration: InputDecoration(
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
                    ? Image.network(widget.imagePath)
                    : Image.file(File(widget.imagePath)),
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
                  decoration: InputDecoration(
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
                    ignoring: isLoading ? true : false, /// rend le bouton non cliquable si il est en train d envoyer la requete
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          try{
                            setState(() {isLoading = true;}); /// lance le chargement du bouton
                            await _getLocation(); /// on recupere la longitude et la latitude (dans les attributs)
                            await postLePost();
                          }catch(e){
                            setState(() {isLoading = false;});
                            Fluttertoast.showToast(msg: '$e');
                          }
                        }
                      },
                      child: (isLoading) ?const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Colors.white,
                          ))
                          : const Text('Valider', style: TextStyle(fontSize: 20) ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// met a jour les attributs longitutide et latitude avec les coordonnees actuelles de l utilisateur
  Future<void> _getLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception('Erreur : service désactivé !');
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception('Erreur : permission manquante');
      }
    }
    _locationData = await location.getLocation();
    longitude = _locationData.longitude.toString() ;
    latitude = _locationData.latitude.toString() ;
  }
  /// renvoie la date du jour au format JJ/MM/AAAA -- affichage utilisateur
  String getCurrentDate() {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    return formattedDate.toString();
  }
  /// renvoie la date du jour au format YYY/MM/DD hh/mm/ss -- pour la BDD
  String getCurrentDateBDD() {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year} ${dateParse.hour}:${dateParse.minute}:${dateParse.second}";
    return formattedDate.toString();
  }

  /// methode appelee lors de la creation du post dans la BDD
  Future postLePost() async {

    String url = Conf.bddDomainUrl + Conf.bddPath + "/post";

    var request = http.MultipartRequest("POST", Uri.parse(url));
    try {
      request.fields['titre']= controllerTitre.text;              /// titre du post
      request.fields['description']= controllerDescription.text;  /// description du post (possible null ou chaine vide jsp)
      request.fields['latitude'] = latitude;                      /// latitude du post
      request.fields['longitude'] = longitude;                    /// longitude du post
      request.fields['date'] = getCurrentDateBDD();               /// date courante au format adapte a la bdd

      UserConneted user = await getUser();
      if(!user.isEmpty()) {
        request.fields['token'] = user.token;                     /// token d authentification de l utilsateur
      }else{
        throw Exception('Erreur : session !');
      }
      List? adresses = await getAdresse();
      if (adresses != null){
        print(adresses[0]);
        print(adresses[1]);
      } else{
        print("raté");
      }
      request.files.add( await
      http.MultipartFile.fromPath(                            ///ajout de la photo a la requete
          "photo", widget.imagePath,contentType: MediaType("image", "jpeg")
      )
      );
      /// on envoie la requete
      request.send().then((response) async {
        http.Response.fromStream(response) /// je crois que ca caste la response en un truc qui me permet de recuperer le body
            .then((response) {
          //print(response.statusCode);
          final Map<String, dynamic> data = json.decode(response.body);
          String res = data['message'];
          //print (res);
          if (response.statusCode == 200) {
            Navigator.of(context).pop();  /// si l 'insertion a reussie on retourne sur la page de l'appareil photo
             /// sinon on reste sur le formulaire, peut etre que le gars va resoudre le probleme tout seul
          } else {
            throw Exception('Erreur : ${response.statusCode} !');
          }
          setState(() {isLoading = false;}); /// termine le chargement du bouton
          showDialog(context: context,
              builder: (BuildContext context) {
                return AdvanceCustomAlert(message: res, statusCode: response.statusCode, );
              });
        });
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
      setState(() {isLoading = false;}); /// termine le chargement du bouton
    }
  }

  Future <List?> getAdresse() async{
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyCoZ5pkSaTZk3rpiGrm3yuTIj48y7NdncU&result_type=street_address|locality';

    try {
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      final Map<String, dynamic> data = json.decode(response.body);

      if(data["status"] == "OK"){ //if status is "OK" returned from REST API
        if(data["results"].length > 0) { //if there is atleast one address
          Map firstresult = data["results"][0]; //select the first address

          var address = firstresult["formatted_address"]; //get the address
          print(address);
        }
      }
      return null;
      //return List<String>.filled(adresse_courte, adresse_longue);

    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Impossible d'accéder à la base de données.");
      return null;
    }
  }
}