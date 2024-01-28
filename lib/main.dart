import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picturetranscriptor/transcription.dart';
import 'package:camera/camera.dart';
import 'TranscriptionVew.dart';
late List<CameraDescription> _cameras;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Historique De Transcription",style: TextStyle(
              color: Color(0xE8AA79F3),
              fontWeight: FontWeight.bold,
              fontFamily: "PirataOne-Regular"),
          ),
          backgroundColor: Colors.white,
        ),
        body: HomePage(),
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  final textDetector =TextRecognizer();
  Future<void> _getImageFromGallery() async {
    try {
      XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        final inputImage = InputImage.fromFilePath(imageFile.path);
        /*TextRecognizer textRecognizer = TextRecognizer();
        RecognizedText recognizedText = await textRecognizer.processImage(inputImage);*/
        //TranscriptionList.transcriptions.add(new Transcription(imageFile.path, recognizedText.text));
        // Vous pouvez naviguer vers la vue de transcription ici
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TranscritionView(picture: imageFile)),
        );
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
        body: Container(
          child: TranscriptionList(),
        ), // Remplacez par votre widget
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
  final TextRecognizer textRecognitionProcessor = GoogleMlKit.vision.textRecognizer();
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    try {
      final image = await controller.takePicture();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>TranscritionView(picture: image)));
    } on CameraException catch (e) {
      print('Une erreur est survenue lors de la prise de photo : ${e.description}');
      // Vous pouvez ajouter ici un code pour gérer l'erreur de manière plus appropriée, par exemple en affichant un message à l'utilisateur.
    } catch (e) {
      print('Une erreur inattendue est survenue : $e');
      // Gérer les autres erreurs non spécifiques à la caméra.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller!.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(controller),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              child: Icon(Icons.camera),
              onPressed: takePicture,
            ),
          ),
        ],
      ),
    );
  }
}

