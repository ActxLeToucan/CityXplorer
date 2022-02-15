import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../pages/display_picture_screen.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  double _sliderValue = 1.0;
  double _zoomMax = 1.01;

  @override
  initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _renderButtons())
            ]);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  List<Widget> _renderButtons() {
    return [
      Container(
          decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black54, spreadRadius: 10)]),
          child: Column(children: [
            IconButton(
                icon: const Icon(Icons.camera_alt),
                color: Colors.white,
                onPressed: () async {
                  // Take the Picture in a try / catch block. If anything goes wrong,
                  // catch the error.
                  try {
                    // Ensure that the camera is initialized.
                    await _initializeControllerFuture;

                    // Attempt to take a picture and get the file `image`
                    // where it was saved.
                    final image = await _controller.takePicture();

                    // If the picture was taken, display it on a new screen.
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayPictureScreen(
                          // Pass the automatically generated path to
                          // the DisplayPictureScreen widget.
                          imagePath: image.path,
                        ),
                      ),
                    );
                  } catch (e) {
                    print(e);
                  }
                }),
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
}
