import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'transcription.dart';
import 'main.dart';
import 'dart:io';

class TranscritionView extends StatefulWidget {
  TranscritionView({required this.picture, Key? key}) : super(key: key);
  XFile picture;
  @override
  State<TranscritionView> createState() => _TranscritionViewState();
}

class _TranscritionViewState extends State<TranscritionView> {
  late String _text='';
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => load());
  }
  void load() async{
    File imageFile = File(widget.picture.path);
    TextRecognizer textRecognizer = TextRecognizer();
    InputImage inputImage = InputImage.fromFilePath(widget.picture.path);
    RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    Transcription transcription=new Transcription(imageFile.path, recognizedText.text);
    TranscriptionList.transcriptions.add(transcription);
    print(TranscriptionList.transcriptions);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
                child: Image.file(File(widget.picture.path))
            ),
            Container(
              child: Text(_text),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (builder)=>HomePage()));
        },
        child: Icon(Icons.home),
      ),
    );
  }
}