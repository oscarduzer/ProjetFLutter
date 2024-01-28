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
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage("empty.gif")
                    ,repeat: ImageRepeat.noRepeat,
                    filterQuality: FilterQuality.high),
                Text("Pas de Transcription Trouvée pour le moment,Capturer ou Importer une photo.",
                textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xE8AA79F3),
                  fontWeight: FontWeight.bold,fontFamily: "PirataOne-Regular"),)
              ],
            ),
          ),
        );
      }
    return ListView.builder(
      itemCount: transcriptions.length,
      itemBuilder: (context, index) {
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
    );

  }
}

