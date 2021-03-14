import 'dart:math';
import 'dart:io' as io;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';

import '../splash.dart';
class MedicalAudio extends StatefulWidget {
  final FirebaseUser user;
  final LocalFileSystem localFileSystem;
  MedicalAudio({this.user,localFileSystem}): this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _MedicalAudioState createState() => _MedicalAudioState();
}

class _MedicalAudioState extends State<MedicalAudio>with TickerProviderStateMixin {
  TextEditingController _address = TextEditingController();
  TextEditingController _controller = new TextEditingController();
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
   AnimationController controller;
   String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${(duration.inMinutes).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 120),
    );
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
    audioAlert(file, randomNumber);
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
final _addressformKey = GlobalKey<FormState>();
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

  audioAlert(file, randomNumber) {
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
                    controller: _address,
                    decoration: InputDecoration(
                      labelText: 'Enter Address',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Colors.blue[700],
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
                        await Firestore.instance.collection('requests').add({
                          'address':_address.text,
                          "services": url,
                          'service_name':'Medicine',
                          "name": widget.user.displayName,
                          "phone": widget.user.phoneNumber,
                          'time': DateTime.now().toIso8601String().substring(11,19),
                          'year': DateTime.now().year,
                          'month': DateTime.now().month,
                          'date': DateTime.now().toString().substring(0, 11)
                        });
                        await Firestore.instance.collection('users').document(widget.user.uid).updateData({'address':_address.text});
                      }),
                ),
              ],
            ),
          ));
        });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:Text('Record Audio'),
        ),
                     body: Container(
                margin: EdgeInsets.all(8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Record Audio'),
                          Icon(Icons.mic),
                        ],
                      ),
                      SizedBox(
                        height: 70,
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
                        height: 60.0,
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
      ),
    );
  }
}