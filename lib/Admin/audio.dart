import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class Audiopage extends StatefulWidget {
  @override
  _AudiopageState createState() => _AudiopageState();
}

class _AudiopageState extends State<Audiopage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:Text('Delete Audio')
        ),
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child:Text('Do you want to delete all your previous month Audio?',
                style: TextStyle(
                  fontSize:24.0,
                ),)
              ),
              FloatingActionButton.extended(onPressed: (){
                Firestore.instance.collection('completed').where('month',isLessThan: DateTime.now().day-7).getDocuments().then((value) async {
      for(DocumentSnapshot ds in value.documents){
        var data = ds.data['services'];
        print(data);
        FirebaseStorage.instance
    .getReferenceFromUrl(data)
    .then((reference){
      FirebaseStorage.instance.ref().child('Requests/$reference').delete();
    })
    .catchError((e) => print(e));
      }
    });
              }, label: Text('Delete Audio'))
            ],
          ),
        )
      ),
    );
  }
}