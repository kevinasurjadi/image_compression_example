import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_compression_example/flutter_image_compress_page.dart';
import 'package:image_compression_example/flutter_native_image_page.dart';

class ControlPage extends StatelessWidget {
  final XFile image;

  const ControlPage({required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FlutterNativeImagePage(image: image),
                  ),
                );
              },
              child: const Text('Flutter Native Image'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        FlutterImageCompressPage(image: image),
                  ),
                );
              },
              child: const Text('Flutter Image Compress'),
            ),
          ],
        ),
      ),
    );
  }
}
