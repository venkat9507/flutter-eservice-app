import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class Deals extends StatefulWidget {
  final FirebaseUser user;
  Deals({this.user});
  @override
  _DealsState createState() => _DealsState();
}

class _DealsState extends State<Deals> {
    TextEditingController _edit = TextEditingController();
    final _editKey = GlobalKey<FormState>();
    final _formKey = GlobalKey<FormState>();
    TextEditingController _name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          title:Text('Todays Deals')
        ),
        body:Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
            stream:Firestore.instance.collection('deals').snapshots(),
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else{
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot data = snapshot.data.documents[index];
                    return Card(
                                          child: Column(
                                children: <Widget>[
                                  Container(
                                    height: MediaQuery.of(context).size.height/2,
                                    child: InkWell(
                                      onLongPress:widget.user.phoneNumber == '+919790077956'? () {
                                         showDialog(context: context,
                            builder: (context){
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                  FlatButton(
                                    onPressed: (){
                                        Navigator.pop(context);
                                    Firestore.instance.collection('deals').document(data.documentID).delete();
                                  }, child: Text('Delete')),
                                  Divider(),
                                  FlatButton(child: Text('Edit'),
                                  onPressed: (){
                                    showDialog(context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        content: Form(
                                          key: _editKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                            TextFormField(
                                              controller: _edit,
                                              decoration: InputDecoration(
                                                labelText: 'Enter Name',
                                              ),
                                            ),
                                            RaisedButton(
                                              color: Colors.blue[700],
                                              child: Text('Update',
                                              style: TextStyle(
                                                color:Colors.white,
                                              ),),
                                              onPressed: (){
                                                Firestore.instance.collection('mainservices').document(data.documentID).updateData({"name":_edit.text});
                                              _editKey.currentState.reset();
                                              Navigator.pop(context);
                                              })
                                          ],),
                                        ),
                                      );
                                    });
                                  },)
                                ],),
                              );
                            });
                                      }:null,
                                          child: Image.network(
                                            data['image'],
                                            fit: BoxFit.contain,
                                          ),
                                    ),
                                  ),
                                  Container(child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(data['name'],
                                    style: TextStyle(
                                      fontSize:18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700]
                                    ),),
                                  ))
                                ],
                              ),
                    );
                  });
              }
            },
          ),
        ),
        floatingActionButton: widget.user.phoneNumber == '+919790077956'||widget.user.phoneNumber =='+917502067869'?
        FloatingActionButton(
          onPressed: (){
             showDialog(
          context:context,
          builder: (context) {
            return AlertDialog(
              content: Form(
                key: _formKey,
                 child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children:[ 
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                        labelText: 'Enter Name'
                      ),
                    ),
                    RaisedButton(
                      color: Colors.blue[700],
                      child: Text('Upload Image'),
                      onPressed: ()async{
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
                       File img = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          final StorageReference ref = FirebaseStorage.instance
                              .ref()
                              .child('Deals/${_name.text}');
                          StorageUploadTask task = ref.putFile(img);
                          StorageTaskSnapshot downloadUrl =
                              (await task.onComplete);
                          String url = (await downloadUrl.ref.getDownloadURL());
                          Firestore.instance
                              .collection('deals')
                              .add({'image': url, 'name': _name.text});
                            Navigator.pop(context);
                    })
                  ]
                ),
              ),
            );
          },);
          },
          child: Icon(Icons.add),
          ):Container()
      ),
    );
  }
}