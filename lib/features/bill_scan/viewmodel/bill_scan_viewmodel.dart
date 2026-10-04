import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BillScanViewModel extends ChangeNotifier {
  CameraController? controller;
  bool isReady = false;
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
      await controller?.initialize();
      isReady = true;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> captureImage() async {
    if (!isReady || controller == null) return "";
    final image = await controller!.takePicture();
    return image.path;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
