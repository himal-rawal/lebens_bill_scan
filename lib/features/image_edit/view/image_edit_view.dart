import 'dart:io';

import 'package:flutter/material.dart';

class ImageEditView extends StatefulWidget {
  final String capturedImage;
  const ImageEditView({super.key, required this.capturedImage});

  @override
  State<ImageEditView> createState() => _ImageEditViewState();
}

class _ImageEditViewState extends State<ImageEditView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Image.file(File(widget.capturedImage))]),
    );
  }
}
