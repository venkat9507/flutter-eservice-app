import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class AnnounceMents extends StatefulWidget {
  @override
  _AnnounceMentsState createState() => _AnnounceMentsState();
}

class _AnnounceMentsState extends State<AnnounceMents> {
  TextEditingController _name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  addannouncement() async {
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
                      labelText: 'New Announcements',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Colors.blue[700],
                      child: Text(
                        'Add Announcement',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                       Firestore.instance.collection('announcement')
                            .add({'name': _name.text, 'date': DateTime.now().toString().substring(0,11),'time':DateTime.now().toIso8601String().toString()});
                          _formKey.currentState.reset();
                          Navigator.pop(context);
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
                  return Slidable(
                    actionPane: SlidableBehindActionPane(),
                    actionExtentRatio: 0.30,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: (){
                          Firestore.instance.collection('announcement').document(data.documentID).delete();
                        },
                      )
                    ],
                    child: Container(
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
                    ),
                  );
                });
            }
          }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            addannouncement();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}