import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GeolocationMap extends StatefulWidget {
  @override
  _GeolocationMapState createState() => _GeolocationMapState();
}

class _GeolocationMapState extends State<GeolocationMap> {

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker User;

  Marker destination = Marker(
  markerId: MarkerId("Ici"),
  position: LatLng(48.692054, 6.184417),
  draggable: false,
  zIndex: 2,
  flat: true,
  anchor: Offset(0.5, 0.5),
  icon: BitmapDescriptor.defaultMarker,
  );

  GoogleMapController _controller;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(48.692054, 6.184417),
    zoom: 14.4746,
  );


  void updateMarkerAndCircle(LocationData newLocalData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      User = Marker(
          markerId: MarkerId("Ici"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarker,
      );
    });
  }

  void getCurrentLocation() async {
    try {

      //Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }


      _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void addMarkerDestination() {
    LatLng latlng = LatLng(48.681,  6.1754);
    this.setState(() {
      destination = Marker(
        markerId: MarkerId("Ici"),
        position: latlng,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarker,
      );
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: initialLocation,


        markers: Set.of((User != null) ? [User] : []),



        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          addMarkerDestination();
          getCurrentLocation();
        },
      ),

    );
  }

}
