import 'dart:async';
import 'package:cityxplorer/models/post.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../models/directionsM.dart';
import '../models/directionsR.dart';

class GeolocationMap extends StatefulWidget {
  final Post post;

  const GeolocationMap({Key? key, required this.post}) : super(key: key);
  @override
  _GeolocationMapState createState() => _GeolocationMapState();
}

class _GeolocationMapState extends State<GeolocationMap> {
  GoogleMapController? _controller;
  final Location _locationTracker = Location();

  StreamSubscription? _locationSubscription;

  Marker? _user;
  Marker? _destination;

  Directions? _data;
  String distance = "";
  String temps = "";

  CameraPosition initialLocation() {
    return CameraPosition(
      target: LatLng(widget.post.latitude, widget.post.longitude),
      zoom: 14.4746,
    );
  }

  void updateMarker(LocationData newLocalData) async {
    LatLng latlng =
        LatLng(newLocalData.latitude ?? 0, newLocalData.longitude ?? 0);

    setState(() {
      _user = Marker(
        markerId: const MarkerId("moi"),
        position: latlng,
        //rotation: newLocalData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    });
    final directions = await DirectionsRepository()
        .getDirections(origin: latlng, destination: _destination!.position);
    setState(() => _data = directions);

    if (_data != null) {
      distance = _data!.totalDistance;
      temps = _data!.totalDuration;
    }
  }

  void getCurrentLocation() async {
    var location = await _locationTracker.getLocation();

    updateMarker(location);

    if (_locationSubscription != null) {
      _locationSubscription?.cancel();
    }

    _locationSubscription =
        _locationTracker.onLocationChanged.listen((newLocalData) {
      if (_controller != null) {
        /*
         _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00)));

           */

        updateMarker(newLocalData);
      }
    });
  }

  void addMarkerDestination(lat, lng) async {
    LatLng latlng = LatLng(lat, lng);
    setState(() {
      _destination = Marker(
        markerId: const MarkerId("lieuPost"),
        position: latlng,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarker,
      );
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*
    BitmapDescriptor customIcon;
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'assets/images/car-icon.png')
        .then((d) {
      customIcon = d;
    });

     */
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Il vous reste $distance, $temps',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: initialLocation(),
            markers: Set.of((_user != null) ? [_user!, _destination!] : []),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              addMarkerDestination(widget.post.latitude, widget.post.longitude);
              /** --------------------------------------------------- **/
              getCurrentLocation();
            },
            polylines: {
              if (_data != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.blue,
                  width: 4,
                  points: _data!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
          ),
        ],
      ),
    );
  }
}
