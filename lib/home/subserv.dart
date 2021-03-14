import 'dart:math';
import 'dart:io' as io;
import 'package:audio_recorder/audio_recorder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eservices/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class SubServ extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  final DocumentSnapshot servdocid, mainservdoc;
  final FirebaseUser user;
  final name;
  SubServ({this.servdocid, this.name, this.mainservdoc,this.user, localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _SubServState createState() => _SubServState();
}

class _SubServState extends State<SubServ> with TickerProviderStateMixin {
  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _controller = new TextEditingController();
  // Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${(duration.inMinutes).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  

  final _formKey = GlobalKey<FormState>();
  Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  final _addressformKey = GlobalKey<FormState>();
  List data = [];
  

  Future<String> getCurrentLocation() async {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();
    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: 'en');
    Placemark placeMark = placemark[0];
    String name = placeMark.name;
    String subLocality = placeMark.thoroughfare;
    String locality = placeMark.locality;
    String administrativeArea = placeMark.administrativeArea;
    String postalCode = placeMark.postalCode;
    String country = placeMark.country;
    String address =
        "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
    print(address);
    return address;
  }

  alert(setList) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Form(
            key: _addressformKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 10,
                    keyboardType: TextInputType.text,
                    controller: _address..text = setList,
                    decoration: InputDecoration(
                      labelText: 'Enter Address',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        'Submit Request',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        stopalert();
                        Firestore.instance
                            .collection('mainservices')
                            .document(widget.mainservdoc.documentID)
                            .collection('services')
                            .document(widget.servdocid.documentID)
                            .collection('subservice')
                            .where('isSelected', isEqualTo: true)
                            .getDocuments()
                            .then((value) {
                          for (DocumentSnapshot ds in value.documents) {
                            data.add(ds.data['name']);
                          }
                          Firestore.instance.collection('requests').add({
                            "service_name": widget.name,
                            "name": widget.user.displayName,
                            "phone": widget.user.phoneNumber,
                            "service": other ? _name.text : data,
                            "address": _address.text,
                            'time': DateTime.now().toIso8601String().substring(12,19),
                            'year': DateTime.now().year,
                            'month': DateTime.now().month,
                            'date': DateTime.now().toString().substring(0, 11)
                          });
                        });
                        Firestore.instance.collection('users').document(widget.user.uid).updateData({'address':_address.text});
                        Firestore.instance
                            .collection('mainservices')
                            .document(widget.mainservdoc.documentID)
                            .collection('services')
                            .document(widget.servdocid.documentID)
                            .collection('subservice')
                            .where('isSelected', isEqualTo: true)
                            .getDocuments()
                            .then((value) {
                          for (DocumentSnapshot ds in value.documents) {
                            ds.reference.updateData({"isSelected": false});
                          }
                        });
                      }),
                ),
              ],
            ),
          ));
        });
  }
  bool other = false;
  AnimationController controller;
  String _setList = null;
 
  void initState() {
    super.initState();
    if (_setList == null) {
      getCurrentLocation().then((String s) => setState(() {
            _setList = s;
          }));
    }
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 120),
    );
  }
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  String setList;
  @override
  Widget build(BuildContext context) {
    setList = _setList;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                size: 30.0,
              ),
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
            )
          ],
          title: Text('${widget.name}'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             Container(
                      height: 180.0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            StreamBuilder(
                              stream: Firestore.instance
                                  .collection('mainservices')
                                  .document(widget.mainservdoc.documentID)
                                  .collection('services')
                                  .document(widget.servdocid.documentID)
                                  .collection('subservice')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot data =
                                          snapshot.data.documents[index];
                                      return CheckboxValue(
                                        title: data['name'],
                                        mainservdoc: widget.mainservdoc,
                                        servdocid: widget.servdocid,
                                        docid: data.documentID,
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
             Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Other',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
               Container(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (value){
                              setState(() {
                                other = true;
                              });
                            },
                            controller: _name,
                            decoration: InputDecoration(
                              labelText: 'Service Name',
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 15.0),
             Center(
                      child: FloatingActionButton.extended(
                        heroTag: Text('btn'),
                        onPressed: () {
                          alert(setList);
                        },
                        label: Text('Submit Request'),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: <Widget>[
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.black,
                          height: 26,
                        )),
                  ),
                  Text("OR"),
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )),
                  ),
                ]),
              ),
              SizedBox(height: 20.0),
              Container(
                  child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Didn't Find the Service you need ?",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      ' You can also Record Audio of the Service you need',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )),
              SizedBox(height: 30.0),
              Container(
                margin: EdgeInsets.all(8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Record Audio'),
                          Icon(Icons.mic),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: <Widget>[
                                FloatingActionButton(
                                  heroTag: Text('btn'),
                                  onPressed: () {
                                    _assetsAudioPlayer.open(
                                      Audio("assets/audio/beep.mp3"),
                                      respectSilentMode: false,
                                      volume: 100.0,
                                      autoStart: true,
                                      showNotification: false,
                                    );
                                    controller.reverse(
                                      from: controller.value == 0.0
                                          ? 1.0
                                          : controller.value,
                                    );
                                    _start();
                                  },
                                  child: AnimatedBuilder(
                                    animation: controller,
                                    builder: (context, child) {
                                      return Icon(Icons.play_arrow);
                                    },
                                  ),
                                ),
                                SizedBox(height:15),
                                Text('Start '),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                FloatingActionButton(
                                  heroTag: Text('btn'),
                                  backgroundColor: Colors.redAccent,
                                  child: AnimatedBuilder(
                                    animation: controller,
                                    builder: (BuildContext context, Widget child) {
                                      return Icon(
                                        Icons.stop,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                  onPressed: () {
                                    controller.stop(canceled: true);
                                    controller.reset();
                                    _stop();
                                  },
                                ),
                                 SizedBox(height:15),
                                Text('Stop'),
                              ],
                            ),
                          ]),
                      SizedBox(
                        height: 20.0,
                      ),
                      AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            return Text(
                              timerString,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
 _start() async {
                  try {
                    if (await AudioRecorder.hasPermissions) {
                      if (_controller.text != null && _controller.text != "") {
                        String path = _controller.text;
                        if (!_controller.text.contains('/')) {
                          io.Directory appDocDirectory =
                              await getApplicationDocumentsDirectory();
                          path = appDocDirectory.path + '/' + _controller.text;
                        }
                        print("Start recording: $path");
                        await AudioRecorder.start(
                            path: path, audioOutputFormat: AudioOutputFormat.AAC);
                      } else {
                        await AudioRecorder.start();
                      }
                      bool isRecording = await AudioRecorder.isRecording;
                      setState(() {
                        _recording = new Recording(duration: new Duration(), path: "");
                        _isRecording = isRecording;
                      });
                    } else {
                      new SnackBar(content: new Text("You must accept permissions"));
                    }
                  } catch (e) {
                    print(e);
                  }
                // await Future.delayed(
                //   const Duration(seconds:120),
                //   _stop(),
                // );
                }

  _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = widget.localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    print('File: $recording');
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
    _controller.text = recording.path;
    Random random = new Random();
    int randomNumber = random.nextInt(900000) + 100000;
    audioAlert(setList, file, randomNumber);
  }

  audioAlert(setList, file, randomNumber) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Form(
            key: _addressformKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 10,
                    keyboardType: TextInputType.text,
                    controller: _address..text = setList,
                    decoration: InputDecoration(
                      labelText: 'Enter Address',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        'Submit Request',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        stopalert();
                        final StorageReference ref = FirebaseStorage.instance
                            .ref()
                            .child('Requests/$randomNumber');
                        StorageUploadTask task = ref.putFile(file);
                        StorageTaskSnapshot downloadUrl =
                            (await task.onComplete);
                        String url = (await downloadUrl.ref.getDownloadURL());
                        Firestore.instance.collection('requests').add({
                          "services": url,
                          "name": widget.user.displayName,
                          "phone": widget.user.phoneNumber,
                          'time': DateTime.now().toIso8601String().substring(12,19),
                          'year': DateTime.now().year,
                          'month': DateTime.now().month,
                          'date': DateTime.now().toString().substring(0, 11)
                        });
                      }),
                ),
              ],
            ),
          ));
        });
  }

  stopalert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You're Done"),
          content: const Text(
              'We recieved your order our person will contact you shorthly'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                SplashScreen();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}

class CheckboxValue extends StatefulWidget {
  final DocumentSnapshot servdocid, mainservdoc;
  final String title, docid;

  CheckboxValue({this.title, this.mainservdoc, this.servdocid, this.docid});

  @override
  _CheckboxValueState createState() => _CheckboxValueState();
}

class _CheckboxValueState extends State<CheckboxValue> {
  bool _valueCheckbox = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        widget.title, 
        style: TextStyle(color: Colors.black),
      ),
      value: _valueCheckbox,
      onChanged: (bool newValue) {
        Map<String, dynamic> update = {
          "isSelected": newValue,
        };
        setState(() {
          _valueCheckbox = newValue;
          Firestore.instance
              .collection('mainservices')
              .document(widget.mainservdoc.documentID)
              .collection('services')
              .document(widget.servdocid.documentID)
              .collection('subservice')
              .document(widget.docid)
              .updateData(update);
        });
      },
    );
  }
}
