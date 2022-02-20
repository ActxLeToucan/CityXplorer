import 'dart:convert';

import 'package:cityxplorer/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../styles.dart';

import 'package:http/http.dart' as http;

import '../conf.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Styles.mainColor,
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
                  cursorColor: Styles.mainColor,
                  textAlign: TextAlign.center,
                  controller: controllerTitre,
                  autofocus: true,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.5),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
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
                  cursorColor: Styles.mainColor,
                  minLines: 2,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  controller: controllerDescription,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.5),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
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
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Styles.mainColor,
                    ),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        try{
                          // on recupere la longitude et la latitude (dans les attributs)
                          await _getLocation();
                          Fluttertoast.showToast(msg: '$longitude' ' et ' '$latitude');

                          //on recupere le token de l user
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          var userString = prefs.getString('user');
                          User user = User.empty();
                          if (userString != null) {
                            user = User.fromJson(jsonDecode(userString));
                            // user controllerTitre.text imagePath controllerDescri.text longitude latitude getCurrentDate()
                            //Fluttertoast.showToast(msg: await postLePost(user));
                          }

                        }catch(e){
                          Fluttertoast.showToast(msg: '$e');
                        }
                      }
                    },
                    child: const Text(
                      'Valider',
                      style: TextStyle(fontSize: 20),
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
  // met a jour les attributs longitutide et latitude avec les coordonnees actuelles de l utilisateur
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
  //renvoie la date du jour au format JJ/MM/AAAA
  String getCurrentDate() {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    return formattedDate.toString();
  }
  // methode appelee lors de la creation du post dans la BDD
  // TODO
  Future<String> postLePost(Future<String> user) async {
    String message = 'rien';

    String url = Conf.bddDomainUrl + Conf.bddPath + "/post";
    try {
      var msg = await http.get(Uri.parse(url));
    } catch (e) {
      print(e);
      message = "Impossible d'accéder à la base de données.";
    }

    return message;
  }
}
