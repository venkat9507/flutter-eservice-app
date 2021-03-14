import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eservices/home/medical_audio.dart';
import 'package:eservices/home/medical_prescription.dart';
import 'package:eservices/home/subserv.dart';
import 'package:eservices/login/login.dart';
import 'package:flutter/material.dart';

class ServicePage extends StatefulWidget {
  final currrentUser;
  final DocumentSnapshot name;
  final service;
  ServicePage({this.currrentUser, this.name,this.service,});
  @override
  _UserHomeState createState() => _UserHomeState();
}
class _UserHomeState extends State<ServicePage> {
  medAlert(){
    showDialog(context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:[
            RaisedButton(
              color: Colors.blue[700],
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Prescription(user: widget.currrentUser,)));
              },
              child: Text('Upload Prescription',
                        style: TextStyle(
                          color: Colors.white,
                        ),),),
              Divider(),
              RaisedButton(
                color: Colors.blue[700],
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MedicalAudio(user: widget.currrentUser,)));
              },
              child: Text('Send Audio Recording',
                        style: TextStyle(
                          color: Colors.white,
                        ),),),
          ]
        ),
      );
    },);
  }
  alert(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children:[
              Text('To submit a Service request , you must be a registered user. Please click Login button to continue'),
              SizedBox(height: 20,),
              FlatButton(
                color: Colors.blue,
                child: Text('Login',
                style: TextStyle(
                  color: Colors.white
                ),),
               onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage(hasdata: true,)),(Route<dynamic> route) => false);              
               },
              )
            ]
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.service}')),
        body: Container(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('mainservices')
                .document(widget.name.documentID)
                .collection('services')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot serv = snapshot.data.documents[index];
                    return InkWell(
                                    onTap: () {
                                      if(widget.currrentUser == null){ 
                                        alert();
                                        }
                                      else{
                                        if(serv['name']=='Medicine'){
                                          medAlert();
                                        }
                                        else{
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SubServ(mainservdoc:widget.name,servdocid: serv, name: serv['name'],user:widget.currrentUser)));
                                        }
                                      }
                                    },
                                    child: Container(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              height: 150,
                                              width: 250,
                                              child: Card(
                                                shape:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
                                                ),
                                                color: Colors.white,
                                                child: Image.network(
                                                    serv['image'],
                                                    fit: BoxFit.cover,),
                                              ),
                                            ),
                                            Container(child: Text(serv['name'],),),
                                          ],),
                                    ),
                                  );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}