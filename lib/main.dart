import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_compression_example/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var cameras = await availableCameras();
  runApp(MyApp(
    cameras: cameras,
  ));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({required this.cameras, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Compression Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        cameras: cameras,
      ),
    );
  }
}
