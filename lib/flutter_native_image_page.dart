import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_compression_example/image_view_page.dart';

enum ResizeType { percentage, specific }

class FlutterNativeImagePage extends StatefulWidget {
  final XFile image;

  const FlutterNativeImagePage({required this.image, Key? key})
      : super(key: key);

  @override
  State<FlutterNativeImagePage> createState() => _FlutterNativeImagePageState();
}

class _FlutterNativeImagePageState extends State<FlutterNativeImagePage> {
  late TextEditingController _widthController;
  late TextEditingController _heightController;

  File? _originalImage;
  File? _compressedImage;

  double _originalFileSize = 0;
  double _compressedFileSize = 0;
  int _originalFileWidth = 0;
  int _originalFileHeight = 0;
  int _compressedFileWidth = 0;
  int _compressedFileHeight = 0;

  int _quality = 70;
  int _percentage = 70;

  bool _isLoading = false;

  Duration _duration = const Duration(milliseconds: 0);

  ResizeType _selectedResizeType = ResizeType.percentage;

  @override
  void initState() {
    _widthController = TextEditingController();
    _heightController = TextEditingController();
    _initialize();
    super.initState();
  }

  void _initialize() async {
    _originalImage = File(widget.image.path);
    _compressedImage = File(widget.image.path);

    var decodedImage =
        await decodeImageFromList(_originalImage!.readAsBytesSync());

    _originalFileSize = await _originalImage!.length() / 1024;
    _originalFileWidth = decodedImage.width;
    _originalFileHeight = decodedImage.height;

    _widthController.text = '$_originalFileWidth';
    _heightController.text = '$_originalFileHeight';

    _compressedFileSize = await _originalImage!.length() / 1024;
    _compressedFileWidth = decodedImage.width;
    _compressedFileHeight = decodedImage.height;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Native Image'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quality'),
                  Slider(
                    value: _quality.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: _quality.toStringAsFixed(0),
                    onChanged: (value) {
                      setState(() {
                        _quality = value.floor();
                      });
                    },
                  ),
                  const Text('Resize'),
                  DropdownButton<ResizeType>(
                    items: ResizeType.values
                        .map(
                          (e) => DropdownMenuItem<ResizeType>(
                            child: Text(
                              describeEnum(e),
                            ),
                            value: e,
                          ),
                        )
                        .toList(),
                    value: _selectedResizeType,
                    onChanged: (value) {
                      setState(() {
                        _selectedResizeType = value!;
                      });
                    },
                  ),
                  if (_selectedResizeType == ResizeType.percentage)
                    Slider(
                      min: 0,
                      max: 100,
                      value: _percentage.toDouble(),
                      label: _percentage.toStringAsFixed(0),
                      onChanged: (value) {
                        setState(() {
                          _percentage = value.floor();
                        });
                      },
                      divisions: 100,
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _widthController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text('X'),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_isLoading) {
                      _isLoading = true;
                      setState(() {});
                      var startTime = DateTime.now();
                      if (_selectedResizeType == ResizeType.percentage) {
                        _compressedImage =
                            await FlutterNativeImage.compressImage(
                          widget.image.path,
                          percentage: _percentage,
                          quality: _quality,
                        );
                      } else {
                        _compressedImage =
                            await FlutterNativeImage.compressImage(
                          widget.image.path,
                          quality: _quality,
                          targetWidth:
                              _selectedResizeType == ResizeType.specific
                                  ? int.parse(_widthController.text)
                                  : 0,
                          targetHeight:
                              _selectedResizeType == ResizeType.specific
                                  ? int.parse(_heightController.text)
                                  : 0,
                        );
                      }
                      _duration = DateTime.now().difference(startTime);
                      var decodedImage = await decodeImageFromList(
                          _compressedImage!.readAsBytesSync());

                      _compressedFileSize =
                          await _compressedImage!.length() / 1000;
                      _compressedFileWidth = decodedImage.width;
                      _compressedFileHeight = decodedImage.height;
                      _isLoading = false;
                    }
                    setState(() {});
                  },
                  child: !_isLoading
                      ? const Text('Compress')
                      : const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text('Processing time: ${_duration.inMilliseconds} ms'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Original',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ImageViewPage(
                                  image: _originalImage!,
                                ),
                              ),
                            );
                          },
                          child: Image.file(
                            File(_originalImage!.path),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                            'Size: ${_originalFileSize.toStringAsFixed(2)} KB'),
                        Text(
                          'Dimension: $_originalFileWidth x $_originalFileHeight',
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Compressed',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ImageViewPage(
                                  image: _compressedImage!,
                                ),
                              ),
                            );
                          },
                          child: Image.file(
                            File(_compressedImage!.path),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                            'Size: ${_compressedFileSize.toStringAsFixed(2)} KB'),
                        Text(
                          'Dimension: $_compressedFileWidth x $_compressedFileHeight',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
