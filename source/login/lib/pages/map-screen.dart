import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login_tutorial/pages/screens.dart';

class GeolocationMap extends StatefulWidget {
  @override
  _GeolocationMapState createState() => _GeolocationMapState();
}

class _GeolocationMapState extends State<GeolocationMap> {
  static const _initialisationCameraPosition = CameraPosition(
    target: LatLng(48.7030784, 6.1669376),
    zoom: 11.5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        initialCameraPosition: _initialisationCameraPosition,
      ),
    );
  }
}
