import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ios_just_audio_bug/sample.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;


class TalkFile {
  final String fileName;
  final String fileTitle;
  final String speakerName;
  final String seriesName;
  final String session;

  TalkFile({this.fileName, this.fileTitle, this.speakerName, this.seriesName, this.session});

  factory TalkFile.fromJSON(Map<String, dynamic> json) {
    return TalkFile(
        fileName: json['fileName'],
        fileTitle: json['fileTitle'],
        speakerName: json['speakerName'],
        seriesName: json['seriesName'],
        session: json['session']
    );
  }
}

class FileScreen extends StatelessWidget {
  List<TalkFile> talkFiles = [];
  String session = "";
  String series = "";
  AudioPlayer player = AudioPlayer();
  String url = "";

 
  FileScreen({Key key, @required this.session, @required this.series}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
        title: Text("Files"),
      );

    return Scaffold(
      appBar: appBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Text('Talks',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          SizedBox(height: 10),

          Expanded(child:
            Container(
              child: getAllTalks(context),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width:0.6))
              ),
            )
          )
          ],
        )
    );
  }

    Widget getAllTalks(context){
      return FutureBuilder<List<TalkFile>>(
        future: APIService.getTalkFilesFromSeries(session, series),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            talkFiles = snapshot.data;
            final talkTiles = <Widget>[];

            for (var i = 0; i < talkFiles.length; i++) {
              talkTiles.add(addListTile(talkFiles[i], context));
              talkTiles.add(Divider(color: Colors.grey));
            }
            return ListView(children: talkTiles);
          } else {
            return LinearProgressIndicator();
          }
        }
      );
    }
    
    ListTile addListTile(TalkFile talkFile, context){ 
      return new ListTile(
        leading: Icon(Icons.audiotrack),
        title: Text(talkFile.fileTitle),
        subtitle: Text(talkFile.speakerName),
        onTap: () => {
          url = 'https://smasby-api20191025092629.azurewebsites.net/api/talkfile' + '/' + session + '/' + series + '/' + talkFile.fileName,

          player.setUrl(url).then((dur) {
            var durInMs = dur.inMilliseconds;

            Navigator.push(context, MaterialPageRoute(builder: (context) => 
              new SamplePage()
            ));

          }),

        }
        // onTap: () => _launchURL(Strings.getTalkFileUrl + '/' + session + '/' + series + '/' + talkFile.fileName.toString())
      );
    }



}












class APIService{

    // GET TALK FILES FOR SERIES
  static Future<List<TalkFile>> getTalkFilesFromSeries(String session, String series) async {
      
    var url = 'https://smasby-api20191025092629.azurewebsites.net/api/talkfile' + '/' + session + '/' + series;
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List parsedList = json.decode(response.body);
      List<TalkFile> talkFilesList =
          parsedList.map((val) => TalkFile.fromJSON(val)).toList();
      return talkFilesList;
    } else {
      throw Exception('Failed to load');
    }
  }




}