import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewPage extends StatelessWidget {
  final File image;

  const ImageViewPage({required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PhotoView(
      imageProvider: FileImage(
        File(
          image.path,
        ),
      ),
    ));
  }
}
