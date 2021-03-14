import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eservices/Admin/history.dart';
import 'package:flutter/material.dart';
import 'package:eservices/Admin/Veiewimage.dart';
class NewRequest extends StatefulWidget {
  @override
  _NewRequestState createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> { 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Request')),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('requests').orderBy('time').snapshots(),
          builder: (context,snapshots){
            if(!snapshots.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              return ListView.builder(
                itemCount: snapshots.data.documents.length,
                itemBuilder: (context,index){
                  DocumentSnapshot data = snapshots.data.documents[index];
                  String prescription = data['prescription'];
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
                           Text('Service Time : ${data['time']}'),
                           data['service'] !=null?
                             Text('Service : ${data['service']}'):
                             data['prescription'] !=
                                                            null
                                                        ? Row(
                                                            children: <Widget>[
                                                              Text(
                                                                  'Prescription : '),
                                                              Container(
                                                                height: 70,
                                                                width: 70,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => ViewPrescription(
                                                                                  url: prescription,
                                                                                )));
                                                                  },
                                                                  child: Card(
                                                                    child: Image.network(
                                                                        prescription,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                             :PlayAudio(url:data['services'])
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