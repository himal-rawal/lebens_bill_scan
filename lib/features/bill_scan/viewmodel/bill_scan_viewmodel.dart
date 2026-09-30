import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BillScanViewModel extends ChangeNotifier {
  CameraController? controller;
  bool isReady = false;
  String? capturedImage;
  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return;
      }
      controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      controller?.initialize();
      isReady = true;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> captureImage() async {
    if (!isReady || controller == null) return;
    final image = await controller!.takePicture();
    capturedImage = image.path;
    notifyListeners();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
