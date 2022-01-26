// A widget that displays the picture taken by the user.
import 'dart:io';
import 'package:cityxplorer/components/appbar_default.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(context),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SingleChildScrollView(
          child: Column(children: [
        kIsWeb ? Image.network(imagePath) : Image.file(File(imagePath)),
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
        )
      ])),
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
}
