import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class AnnounceMents extends StatefulWidget {
  @override
  _AnnounceMentsState createState() => _AnnounceMentsState();
}

class _AnnounceMentsState extends State<AnnounceMents> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          title:Text('Announcements'),
        ),
        body:StreamBuilder(
          stream:Firestore.instance.collection('announcement').orderBy('time').snapshots(),
          builder:(context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context,index){
                  DocumentSnapshot data = snapshot.data.documents[index];
                  return Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Container(child:Text('Posted on: ${data['date']}'),),
                  Divider(),
                  Text(data['name'],
                  style: TextStyle(
                    fontSize: 18.0,
                  ),),
                  ],
                ),
              ),
                    ),
                  );
                });
            }
          }
        ),
        
      ),
    );
  }
}