// A widget that displays the picture taken by the user.
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:exif/exif.dart';
import 'package:location/location.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SingleChildScrollView(
          child: Column(children: [
            kIsWeb ? Image.network(imagePath) :Image.file(File(imagePath)),
        FutureBuilder<String>(
          future: printExifOf(imagePath),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // If the Future is complete, display the preview.
              return Text('${snapshot.data}');
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
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

  Future<String> printExifOf(String path) async {
    dynamic fileBytes;
    if (kIsWeb) {

    } else {
      fileBytes = File(path).readAsBytesSync();
    }
    final data = await readExifFromBytes(fileBytes);

    String texte = '';

    if (data.isEmpty) {
      return 'No EXIF information found';
    }

    if (data.containsKey('JPEGThumbnail')) {
      texte = '$texte\nFile has JPEG thumbnail';
      data.remove('JPEGThumbnail');
    }
    if (data.containsKey('TIFFThumbnail')) {
      texte = '$texte\nFile has TIFF thumbnail';
      data.remove('TIFFThumbnail');
    }

    for (final entry in data.entries) {
      texte = '$texte\n${entry.key}: ${entry.value}';
    }

    return texte;
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
