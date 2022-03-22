import 'package:camera/camera.dart';
import 'package:cityxplorer/pages/new_post.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  CameraDescription? _camera;
  bool isLoading = false;
  bool cameraLoaded = false;

  double _sliderValue = 1.0;
  double _zoomMax = 1.01;

  @override
  initState() {
    super.initState();

    availableCameras().then((cameras) {
      _camera = cameras.first;

      // To display the current output from the Camera,
      // create a CameraController.
      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        _camera!,
        // Define the resolution to use.
        ResolutionPreset.max,
      );

      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize();

      cameraLoaded = true;
      setState(() {});
    }).onError((error, stackTrace) {
      print(error);
      cameraLoaded = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraLoaded) {
      if (_camera != null) {
        return FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                _controller.getMaxZoomLevel().then((value) => _zoomMax = value);

                return Stack(children: [
                  ListView(
                    children: [CameraPreview(_controller)],
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  IgnorePointer(
                    /// rend le bouton non cliquable si il est en train d envoyer la requete
                    ignoring: isLoading ? true : false,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _renderButtons()),
                  )
                ]);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            });
      } else {
        return const Center(child: Text("Erreur camera"));
      }
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  List<Widget> _renderButtons() {
    return [
      Container(
          decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black54, spreadRadius: 10)]),
          child: Column(children: [
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  await _initializeControllerFuture;

                  // Attempt to take a picture and get the file `image`
                  // where it was saved.
                  final image = await _controller.takePicture();
                  final location = await _getLocation();

                  // If the picture was taken, display it on a new screen.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      //builder: (context) => DisplayPictureScreen(
                      builder: (context) => NewPostScreen(
                          // Pass the automatically generated path to
                          // the DisplayPictureScreen widget.
                          imagePath: image.path,
                          latitude: location[0] ?? 0,
                          longitude: location[1] ?? 0),
                    ),
                  );
                } catch (e) {
                  print(e);
                }

                setState(() {
                  isLoading = false;
                });
              },
              child: (isLoading)
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Colors.white,
                      ))
                  : const Icon(Icons.camera_alt, color: Colors.white),
            ),
            Slider(
                value: _sliderValue,
                onChanged: (dynamic newValue) {
                  setState(() {
                    _sliderValue = newValue;
                    _controller.setZoomLevel(newValue);
                  });
                },
                min: 1,
                max: _zoomMax)
          ]))
    ];
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
        Fluttertoast.showToast(msg: 'Erreur : service désactivé !');
        return res;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Fluttertoast.showToast(msg: 'Erreur : permission manquante');
        return res;
      }
    }

    _locationData = await location.getLocation();
    res = [_locationData.latitude, _locationData.longitude];

    return res;
  }
}
