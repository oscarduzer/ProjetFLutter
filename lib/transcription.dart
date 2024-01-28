import 'package:flutter/material.dart';

class Transcription {
  final String image;
  final String text;

  Transcription(this.image, this.text);
}


class TranscriptionList extends StatefulWidget {
  const TranscriptionList({super.key});

  static List<Transcription> transcriptions=[];
  State<TranscriptionList> createState() => _TranscriptionListState();
}

class _TranscriptionListState extends State<TranscriptionList> {
  get transcriptions => TranscriptionList.transcriptions;
  @override
  Widget build(BuildContext context) {
    if(transcriptions.length==0)
      {
        return Center(
          child: Text("Aucune Transcription Pour le moment"),
        );
      }
    return ListView.builder(
      itemCount: transcriptions.length + 1, // Ajoutez 1 pour l'en-tête
      itemBuilder: (context, index) {
        if (index == 0) {
          // C'est l'en-tête
          return Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Text(
              'En-tête',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        } else {
          index = index - 1; // Réduisez l'index de 1 pour les éléments de la liste
          return ListTile(
            leading: Image.network(
              transcriptions[index].image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(transcriptions[index].text),
            trailing: IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Image.network(
                              transcriptions[index].image,
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(transcriptions[index].text),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );

  }
}

