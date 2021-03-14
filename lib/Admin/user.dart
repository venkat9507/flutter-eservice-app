import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UserData extends StatefulWidget {
  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title:Text('User Details')
        ),
        body: Container(
          child:StreamBuilder(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(
                  child:CircularProgressIndicator()
                );
                }
                else{
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context,index){
                      DocumentSnapshot data = snapshot.data.documents[index];
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Name : ${data['name']}'),
                            Text('Phone : ${data['phone']}'),
                            Text('Address : ${data['address']}')
                          ],),
                      );
                    });
                }
            },
          )
        ),
      ),
    );
  }
}