import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
class YearlyReports extends StatefulWidget {
  final initial,last;
  YearlyReports({this.initial,this.last});
  @override
  _YearlyReportsState createState() => _YearlyReportsState();
}

class Record {
  final String name;
  final String service;
    final String services;
  final String phone;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['phone'] != null),
        name = map['name'],
        service = map['service'],
        services = map['services'],
        phone = map['phone'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$phone:$service>";
}



class _YearlyReportsState extends State<YearlyReports> {
  bool _isPlaying = false;
  AudioPlayer audioPlayer;
   @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.initial} - ${widget.last}')),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('completed').where('date',isGreaterThanOrEqualTo:widget.initial).where('date',isLessThanOrEqualTo:widget.last).snapshots(),
          builder: (context,snapshots){
            if(!snapshots.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              return ListView.builder(
                itemCount: snapshots.data.documents.length,
                itemBuilder: (context,index){
                  DocumentSnapshot data = snapshots.data.documents[index];
                  return Container(
                    height: 200,
                    child: Card(
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children:[
                           Text('Name : ${data['name']}',
                           style: TextStyle(
                             fontWeight: FontWeight.bold,
                           ),),
                           Text('Phone :${data['phone']}'),
                           Text('Service Category :${data['service_name']}'),
                           Text('Service Date : ${data['date']}'),
                           data['service'] !=null?
                             Text('Service : ${data['service']}'):
                              IconButton(
                          icon:
                              Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
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
                              playAudio(data['services']);
                            }
                          }),
                         ]
                       ),
                    ),
                  );
                });
            }
          }),
      ),
    );}
}