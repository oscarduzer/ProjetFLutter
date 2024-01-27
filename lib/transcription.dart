import 'package:flutter/material.dart';



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