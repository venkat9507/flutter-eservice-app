import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SubService extends StatefulWidget {
  final DocumentSnapshot mainservid,subcat;
  final name;
  SubService({this.mainservid, this.name,this.subcat});
  @override
  _SubServiceState createState() => _SubServiceState();
}

class _SubServiceState extends State<SubService> {
  TextEditingController _name = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  addService() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: 'Service Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Colors.blue[700],
                      child: Text(
                        'Add Service',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {

                        Firestore.instance.collection('mainservices').document(widget.mainservid.documentID).collection('services').document(widget.subcat.documentID).collection('subservice')
                            .add({'name': _name.text});
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.reset();
                          Navigator.pop(context);
                        }
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
          title: Text(widget.name),
        ),
        body: Container(
    child: StreamBuilder(
      stream: Firestore.instance.collection('mainservices').document(widget.mainservid.documentID).collection('services').document(widget.subcat.documentID).collection('subservice').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator()
          );
        }
        else {
          return ListView.builder(
            itemCount:  snapshot.data.documents.length,
            itemBuilder: (context, index){
              DocumentSnapshot serv = snapshot.data.documents[index];
              return Container(
                margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: InkWell(
                  onLongPress: () {
                         showDialog(context: context,
                        builder: (context){
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                              FlatButton(
                                onPressed: (){
                                 Firestore.instance.collection('mainservices').document(widget.mainservid.documentID).collection('services').document(widget.subcat.documentID).collection('subservice').document(serv.documentID).delete();
                                 Navigator.pop(context);
                              }, child: Text('Delete')),
                              Divider(),
                              FlatButton(child: Text('Cancel'),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              )
                            ],),
                          );
                        });
                  },
                                  child: CheckboxListTile(
                    value: false,
                    title: Text(serv['name'],),
                    onChanged: null,
                    ),
                ),
              );
            },
            );
        }
      },
    )
    ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              addService();
            }),
      ),
    );
  }
}
