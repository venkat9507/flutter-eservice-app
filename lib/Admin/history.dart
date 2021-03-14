import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:toast/toast.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: Container(
          child: StreamBuilder(
              stream: Firestore.instance.collection('completed').orderBy('time').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data.documents[index];
                      String url = data['services'];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Date : ${data['date']}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              'Name : ${data['name']}',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              'Phone No : ${data['phone']}',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                             Text( 
                              'Date : ${data['date']}',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            data['service'] != null
                                ? Text(
                                    'Service Name : ${data['service']}',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  )
                                : PlayAudio(
                                  url: url,
                                ),
                            Divider(
                              color: Colors.black54,
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ),
    );
  }
}
class PlayAudio extends StatefulWidget {
  final String url;
  PlayAudio({this.url});
  @override
  _PlayAudioState createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {

 AudioPlayer audioPlayer;
 bool _isPlaying = false;
  playAudio(url) async {
    int response = await audioPlayer.play(url, isLocal: false);

    if (response == 1) {
      // success

    } else {
      print('Some error occured in playing Audio');
    }
  }

  pauseAudio() async {
    int response = await audioPlayer.pause();

    if (response == 1) {
      // success

    } else {
      print('Some error occured in pausing');
    }
  }

  stopAudio() async {
    int response = await audioPlayer.stop();

    if (response == 1) {
    } else {
      Toast.show('Some error occured please try again', context,
          duration: Toast.LENGTH_SHORT);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
       audioPlayer = AudioPlayer();
  }

  resumeAudio() async {
    int response = await audioPlayer.resume();

    if (response == 1) {
    } else {
      Toast.show('Some error occured in resuming', context,
          duration: Toast.LENGTH_SHORT);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Row(
                                    children: <Widget>[
                                      Text(
                                        'Service Audio : ',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      IconButton(
                                          icon: Icon(_isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow),
                                          onPressed: () {
                                            if (_isPlaying == true) {
                                              pauseAudio();
                                              setState(() {
                                                _isPlaying = false;
                                              });
                                            } else {
                                              setState(() {
                                                _isPlaying = true;
                                              });
                                              playAudio(widget.url);
                                            }
                                          }),
                                    ],
                                  );
  }
}
