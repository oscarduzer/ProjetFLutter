import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

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

class Transcription {
  final String image;
  final String text;

  Transcription(this.image, this.text);
}


class TranscriptionList extends StatelessWidget {
  static List<Transcription> _transcriptions=[];

  static void savetranscription(Transcription transcription)
  {
    _transcriptions.add(transcription);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _transcriptions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(_transcriptions[index].image),
          title: Text(_transcriptions[index].text),
          trailing: IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Ajoutez votre code pour partager le texte ici
            },
          ),
        );
      },
    );
  }
}
