import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
class SubCategoryPage extends StatefulWidget {
  final name;
  SubCategoryPage({this.name});
  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
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


class _SubCategoryPageState extends State<SubCategoryPage> {
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
      appBar: AppBar(title: Text('${widget.name} Reports')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('completed')
          .where('service_name', isEqualTo: widget.name)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 10.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Service')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text(
                record.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              DataCell(Text(record.phone)),
              record.service != null
                  ? DataCell(Text(record.service))
                  : DataCell(
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
                              playAudio(record.services);
                            }
                          }),
                    )
            ])
          ],
        ),
      ),
    );
  }
}