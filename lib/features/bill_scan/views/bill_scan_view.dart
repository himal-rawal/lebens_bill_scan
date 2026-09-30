import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lebens_bill_scan/features/bill_scan/viewmodel/bill_scan_viewmodel.dart';
import 'package:lebens_bill_scan/features/image_edit/views/image_edit_view.dart';

class BillScanView extends StatefulWidget {
  const BillScanView({super.key});

  @override
  State<BillScanView> createState() => _BillScanViewState();
}

class _BillScanViewState extends State<BillScanView> {
  late final BillScanViewModel _billScanViewModel;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _billScanViewModel = BillScanViewModel();
    _billScanViewModel.initializeCamera();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _billScanViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _billScanViewModel,
      builder: (context, child) {
        if (!_billScanViewModel.isReady ||
            _billScanViewModel.controller == null) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: CameraPreview(_billScanViewModel.controller!),
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final capturedImage = await _billScanViewModel
                            .captureImage();
                        if (context.mounted && capturedImage.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ImageEditView(capturedImage: capturedImage),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//  The whole process
// OPen the camera and click the picture of the bill
// Crop the image to remove unwanted parts 
// OCR to read the text from image
// COnvert the text to flutter object and send back to the parent app through callback