import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../components/custom_camera_preview.dart';

/// class qui recupere la camera puis qui construit la page avec un custom_camera_preview
class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? controller;
  late List cameras;
  late int selectedCameraIdx;
  late String imagePath;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.isNotEmpty) {
        setState(() {
          selectedCameraIdx = 0;
        });
        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);
    controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (controller!.value.hasError) {
        print('Camera error ${controller!.value.errorDescription}');
      }
    });
    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      print(e.description);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(
          child: CircularProgressIndicator(
        color: Colors.red,
      ));
    }
    return CustomCameraPreview(
      cameraController: controller!,
    );
  }
}
