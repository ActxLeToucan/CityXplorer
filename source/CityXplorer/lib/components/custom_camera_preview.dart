import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cityxplorer/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../conf.dart';
import '../router/delegate.dart';

//ignore: must_be_immutable
class CustomCameraPreview extends StatefulWidget {
  CameraController cameraController;
  CustomCameraPreview({Key? key, required this.cameraController})
      : super(key: key);

  @override
  _CustomCameraPreviewState createState() => _CustomCameraPreviewState();
}

class _CustomCameraPreviewState extends State<CustomCameraPreview> {
  final routerDelegate = Get.find<MyRouterDelegate>();
  // isLoading est utilise ici pour laisser le temps a l application de calculer l adresse lorsqu il n y a qu une photo de prise
  // sinon l utilisateur pourrait prendre une photo et appuyer rapidement sur valider sans qu on est sa localisation
  bool isLoading = false;

  /// affichage du  slider de zoom
  bool zoomON = true;
  double _sliderValue = 1.0;
  double _zoomMax = 1.0;

  /// liste de photos prises
  List<File> imageFiles = [];

  /// liste des localisations correspondates
  List<List<double>> imageLocations = [];

  @override
  void initState() {
    super.initState();
    widget.cameraController.getMaxZoomLevel().then((value) => _zoomMax = value);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: FractionalOffset.center,
      children: <Widget>[
        Positioned.fill(
          child: AspectRatio(
              aspectRatio: widget.cameraController.value.aspectRatio,
              child: CameraPreview(widget.cameraController)),
        ),
        Positioned(
            bottom: 5,
            child: FloatingActionButton(
              heroTag: "camera",
              backgroundColor: Colors.white,
              onPressed: () async {
                try {
                  //you can give limit that's user can take how many photo
                  if (imageFiles.length != Conf.maxPhotos) {
                    if (imageFiles.isEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                    }
                    //take a photo
                    var videoFile = await widget.cameraController.takePicture();
                    File file = File(videoFile.path);
                    //add photo into files list
                    imageFiles.add(file);
                    // le nullSafety me fait galerer de fou du coup ca donne ca
                    var location = await _getLocation();
                    var latitude = (location[0] ?? 0);
                    var longitude = (location[1] ?? 0);
                    List<double> locationPasNull = [latitude, longitude];
                    imageLocations.add(locationPasNull);
                    setState(() {
                      isLoading = false;
                    });
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                      backgroundColor:
                          Styles.darkMode ? Styles.darkRed : Colors.redAccent,
                      msg: 'Une erreur s\'est produite');
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: const Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
            )),
        _confirmButton(),
        _zoomButton(),
        Positioned(
            bottom: 80,
            child: SizedBox(
              height: 80,
              width: context.width,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: Colors.white)),
                    child: index >= imageFiles.length
                        ? Container(color: Colors.white30, width: 100)
                        : Stack(
                            children: [
                              Image.file(
                                imageFiles[index],
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ),
                              Positioned(
                                top: 2.5,
                                right: 2.5,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        imageFiles.removeAt(index);
                                        imageLocations.removeAt(index);
                                      });
                                    },
                                    child: const Icon(Icons.close,
                                        size: 12, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  );
                },
                itemCount: Conf.maxPhotos,
              ),
            )),
        // slider de zoom
        Positioned(
          right: 5,
          child: RotatedBox(
            quarterTurns: 3,
            child: SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width / 2,
              child: (zoomON)
                  ? Slider(
                      value: _sliderValue,
                      max: _zoomMax,
                      min: 1,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white30,
                      onChanged: (dynamic newValue) {
                        setState(() {
                          _sliderValue = newValue;
                          widget.cameraController.setZoomLevel(newValue);
                        });
                      },
                    )
                  : Container(),
            ),
          ),
        )
      ],
    );
  }

  Positioned _zoomButton() {
    return Positioned(
      bottom: 5,
      left: 5,
      child: FloatingActionButton(
        // lorsqu'il y a plusieurs floating action buttons on doit mettre un tag
        backgroundColor: Colors.black,
        onPressed: () async {
          setState(() {
            zoomON = !zoomON;
          });
        },
        child: const Icon(
          Icons.zoom_in,
          color: Colors.white,
        ),
      ),
    );
  }

  Positioned _confirmButton() {
    return Positioned(
        bottom: 5,
        right: 5,
        child: IgnorePointer(
          /// rend le bouton non cliquable si il est en train d envoyer la requete
          ignoring: isLoading ? true : false,
          child: FloatingActionButton(
            // lorsqu'il y a plusieurs floating action buttons on doit mettre un tag
            heroTag: "confirm",
            backgroundColor: Colors.black,
            onPressed: () async {
              if (imageFiles.isEmpty) {
                Fluttertoast.showToast(
                    backgroundColor:
                        Styles.darkMode ? Styles.darkRed : Colors.redAccent,
                    msg: 'Prenez au moins une photo pour continuer');
              } else {
                List imagePaths = [];
                for (var file in imageFiles) {
                  imagePaths.add(file.path);
                }
                routerDelegate.pushPage(name: '/new_post', arguments: {
                  'photos': imagePaths.join(","),
                  //'imagePath': imageFiles[0].path,
                  'latitude': (imageLocations.first[0]).toString(),
                  'longitude': (imageLocations.first[1]).toString(),
                });
                // vide la liste de photos et met a jour l affichage
                imageFiles.clear();
                imageLocations.clear();
                setState(() {});
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
                : const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
          ),
        ));
  }
}

Future<List<double?>> _getLocation() async {
  Location location = Location();

  List<double?> res = [0, 0];

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      Fluttertoast.showToast(
          backgroundColor: Styles.darkMode ? Styles.darkRed : Colors.redAccent,
          msg: 'Erreur : service désactivé !');
      return res;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      Fluttertoast.showToast(
          backgroundColor: Styles.darkMode ? Styles.darkRed : Colors.redAccent,
          msg: 'Erreur : permission manquante');
      return res;
    }
  }

  _locationData = await location.getLocation();
  res = [_locationData.latitude, _locationData.longitude];

  return res;
}
