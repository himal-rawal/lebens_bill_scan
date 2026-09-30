import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lebens_bill_scan/core/services/image_cropper_service.dart';

class ImageEditView extends StatefulWidget {
  final String capturedImage;
  const ImageEditView({super.key, required this.capturedImage});

  @override
  State<ImageEditView> createState() => _ImageEditViewState();
}

class _ImageEditViewState extends State<ImageEditView> {
  late String currentImagePath;

  @override
  void initState() {
    super.initState();
    currentImagePath = widget.capturedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _imageEditAppBar(context),
            SizedBox(height: 20),
            Center(child: Image.file(File(currentImagePath))),
          ],
        ),
      ),
    );
  }

  Row _imageEditAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, color: Colors.black, size: 30),
        ),
        SizedBox(width: 10),
        Text(
          'Image Preview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        IconButton(
          onPressed: () async {
            final String croppedPath = await ImageCropperService.cropImage(
              currentImagePath,
            );
            if (croppedPath.isNotEmpty && mounted) {
              setState(() {
                currentImagePath = croppedPath;
              });
            }
          },
          icon: Icon(Icons.crop_sharp, color: Colors.black),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Done',
            style: TextStyle(
              color: Colors.green,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
