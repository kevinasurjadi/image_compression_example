import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_compression_example/control_page.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomePage({required this.cameras, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late CameraController _cameraController;

  @override
  void initState() {
    _cameraController = CameraController(
      widget.cameras.length > 1 ? widget.cameras[1] : widget.cameras[0],
      ResolutionPreset.veryHigh,
    );
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _cameraController.setFlashMode(FlashMode.off);
      setState(() {});
    }).catchError((e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            log('User denied camera access');
            break;
          default:
            log('Another error');
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var deviceRatio = size.width / size.height;

    return Scaffold(
      body: _cameraController.value.isInitialized
          ? AspectRatio(
              aspectRatio: deviceRatio,
              child: CameraPreview(_cameraController),
            )
          : const SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var image = await _cameraController.takePicture();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ControlPage(image: image)),
          );
        },
        child: const Icon(
          Icons.camera_alt_outlined,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
