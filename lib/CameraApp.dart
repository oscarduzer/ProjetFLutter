import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'transcription.dart';
import 'HomePage.dart';
class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  final textDetector = TextRecognizer();

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      controller = CameraController(cameras[0], ResolutionPreset.max);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } catch (e) {
      print('Une erreur est survenue lors de l\'initialisation de la caméra : $e');
    }
  }

  Future<void> takePictureAndTranscribe() async {
    try {
      final image = await controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final recognisedText = await textDetector.processImage(inputImage);
      final text = recognisedText.text;
      Transcription transcription=new Transcription(image.path, text);
      TranscriptionList.savetranscription(transcription);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    } catch (e) {
      print('Une erreur est survenue lors de la prise de photo : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: controller!.value.aspectRatio,
      child: Stack(
        children: <Widget>[
          CameraPreview(controller!),
          Positioned(
            bottom: 0,
            child: FloatingActionButton(
              child: Icon(Icons.camera),
              onPressed: takePictureAndTranscribe,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}