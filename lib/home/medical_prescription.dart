import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../splash.dart';

class Prescription extends StatefulWidget {
  final FirebaseUser user;
  Prescription({this.user});
  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Prescription'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            FloatingActionButton.extended(
              onPressed: () async {
                 showDialog(
          context:context,
          builder: (context) {
            return AlertDialog(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[ 
                  CircularProgressIndicator(),
                  Text('Loading...'),
                ]
              ),
            );
          },);
                File img =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                final StorageReference ref = FirebaseStorage.instance
                    .ref()
                    .child('prescription/${_address.text}');
                StorageUploadTask task = ref.putFile(img);
                StorageTaskSnapshot downloadUrl = (await task.onComplete);
                String url = (await downloadUrl.ref.getDownloadURL());
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _address,
                              decoration: InputDecoration(
                                  labelText: 'Enter your Address'),
                            ),
                          ),
                          RaisedButton(
                            color: Colors.blue[700],
                            onPressed: () {
                              stopalert();
                              Firestore.instance.collection('requests').add({
                                "service_name": 'Medicine',
                                "name": widget.user.displayName,
                                "phone": widget.user.phoneNumber,
                                "service": url,
                                "address": _address.text,
                                'time': DateTime.now()
                                    .toIso8601String()
                                    .substring(12, 19),
                                'year': DateTime.now().year,
                                'month': DateTime.now().month,
                                'date': DateTime.now().toString().substring(0, 11)
                              });
                              Firestore.instance
                                  .collection('users')
                                  .document(widget.user.uid)
                                  .updateData({'address': _address.text});
                            },
                            child: Text('Submit',
                          style: TextStyle(
                            color: Colors.white,
                          ),),
                          ),
                        ],
                      ),
                    ));
                  },
                );
              },
              label: Text('Camera'),
              icon: Icon(Icons.photo_camera),
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                File img =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                final StorageReference ref = FirebaseStorage.instance
                    .ref()
                    .child('prescription/${widget.user.displayName}');
                StorageUploadTask task = ref.putFile(img);
                StorageTaskSnapshot downloadUrl = (await task.onComplete);
                String url = (await downloadUrl.ref.getDownloadURL());
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _address,
                              decoration: InputDecoration(
                                  labelText: 'Enter your Address'),
                            ),
                          ),
                          RaisedButton(
                            color: Colors.blue[700],
                            onPressed: () {
                              stopalert();
                              Firestore.instance.collection('requests').add({
                                "service_name": 'Medicine',
                                "name": widget.user.displayName,
                                "phone": widget.user.phoneNumber,
                                "prescription": url,
                                "address": _address.text,
                                'time': DateTime.now()
                                    .toIso8601String()
                                    .substring(12, 19),
                                'year': DateTime.now().year,
                                'month': DateTime.now().month,
                                'date': DateTime.now().toString().substring(0, 11)
                              });
                              Firestore.instance
                                  .collection('users')
                                  .document(widget.user.uid)
                                  .updateData({'address': _address.text});
                            },
                            child: Text('Submit',
                          style: TextStyle(
                            color: Colors.white,
                          ),),
                          ),
                        ],
                      ),
                    ));
                  },
                );
              },
              label: Text('Gallery'),
              icon: Icon(Icons.photo),
            ),
          ]),
        ),
      ),
    );
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
