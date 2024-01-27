import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'transcription.dart';
import 'CameraApp.dart';
class HomePage extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  final textDetector =TextRecognizer(script: TextRecognitionScript.latin);
  Future<void> _getImageFromGallery() async {
    try {
      XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        final inputImage = InputImage.fromFilePath(imageFile.path);
        final recognisedText = await textDetector.processImage(inputImage);
        final text = recognisedText.text;
        Transcription transcription=new Transcription(imageFile.path, text);
        TranscriptionList.savetranscription(transcription);
      }
    } catch (e) {
      print('Une erreur est survenue lors de la récupération de l\'image : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(), // Remplacez par votre widget
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "cameraButton", // Ajout d'un tag unique
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraScreen()),
                );
              },
              tooltip: 'Prendre une photo',
              child: Icon(Icons.camera),
            ),
            SizedBox(width: 10), // Espacement entre les boutons
            FloatingActionButton(
              heroTag: "photoLibraryButton", // Ajout d'un tag unique
              onPressed: _getImageFromGallery,
              tooltip: 'Importer une photo',
              child: Icon(Icons.photo_library),
            ),
          ],
        ),
      ),
    );
  }
}