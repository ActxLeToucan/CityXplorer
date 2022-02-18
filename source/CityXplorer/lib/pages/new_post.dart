import 'package:location/location.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../styles.dart';

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
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              /**
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: FutureBuilder<String>(
                  future: _getLocation(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text('${snapshot.data}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),**/
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
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(controllerTitre.text +
                                  " " +
                                  controllerDescription.text)),
                        );
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

  Future<String> _getLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return 'Erreur : service désactivé !';
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return 'Erreur : permission manquante';
      }
    }
    _locationData = await location.getLocation();
    return _locationData.toString();
  }

  String getCurrentDate() {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    return formattedDate.toString();
  }
}
