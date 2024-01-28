import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:picturetranscriptor/main.dart';


class TranscritionView extends StatefulWidget {
  TranscritionView({required this.picture, Key? key}) : super(key: key);
  XFile picture;
  @override
  State<TranscritionView> createState() => _TranscritionViewState();
}

class _TranscritionViewState extends State<TranscritionView> {
  late File imageFile;
  late InputImage inputImage;

  @override
  void initState(){
    super.initState();
    load();
  }
 void load() async{
   imageFile = File(widget.picture.path);
   TextRecognizer textRecognizer = TextRecognizer();
   inputImage = InputImage.fromFilePath(widget.picture.path);
   RecognizedText recognisedText = await textRecognizer.processImage(inputImage);
   Transcription transcription=new Transcription(imageFile.path, recognisedText.text);
   TranscriptionList.setState(transcription);
   print(TranscriptionList._transcriptions);
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
                child: Image.network(imageFile.path)
            ),
            Container(
              child: Text(''),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (builder)=>MyApp()));
          },
        child: Icon(Icons.home),
      ),
    );
  }
}






class Transcription {
  final String image;
  final String text;

  Transcription(this.image, this.text);
}


class TranscriptionList extends StatelessWidget {
  static List<Transcription> _transcriptions=[];

  static setState(Transcription transcription)
  {
    savetranscription(transcription);
  }
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
