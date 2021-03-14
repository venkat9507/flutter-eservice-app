import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eservices/Admin/subcategory.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminService extends StatefulWidget {
  @override
  _AdminServiceState createState() => _AdminServiceState();
}

class _AdminServiceState extends State<AdminService> {
  TextEditingController _name = TextEditingController();
  TextEditingController _edit = TextEditingController();

  final _formKey = GlobalKey<FormState>();
    final _editKey = GlobalKey<FormState>();

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
                            .child('MainServices/${_name.text}');
                        StorageUploadTask task = ref.putFile(img);
                        StorageTaskSnapshot downloadUrl =
                            (await task.onComplete);
                        String url = (await downloadUrl.ref.getDownloadURL());

                        Firestore.instance
                            .collection('mainservices')
                            .add({'image': url, 'name': _name.text});
                          Navigator.pop(context);
                          Navigator.pop(context);
                      }),
                ),
                Text('*This Button will navigate you to select the icon for the Service',
                style: TextStyle(fontSize: 12.0,
                color: Colors.black45),)
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
          title: Text('Category'),
        ),
        body: Container(
    child: StreamBuilder(
      stream: Firestore.instance.collection('mainservices').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator()
          );
        }
        else {
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount:  snapshot.data.documents.length,
            itemBuilder: (context, index){
              DocumentSnapshot serv = snapshot.data.documents[index];
              return Container(
                margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onLongPress: (){
                        showDialog(context: context,
                        builder: (context){
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                              FlatButton(
                                onPressed: (){
                                    Navigator.pop(context);
                                Firestore.instance.collection('mainservices').document(serv.documentID).delete();
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
                                            Firestore.instance.collection('mainservices').document(serv.documentID).updateData({"name":_edit.text});
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
                        
                      },
                      onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> SubCategory(name:serv['name'], mainservid: serv,)));
                          },
                    child: Container(
                        height: 100,
                        width: 250,
                        child: Card(
                          child: Image.network(serv['image'],
                          fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                    Text(serv['name'])
                  ]
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
