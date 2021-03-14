import 'dart:async';
import 'package:eservices/home/about.dart';
import 'package:eservices/home/deals.dart';
import 'package:eservices/login/login.dart';
import 'package:eservices/login/phoneauth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eservices/home/service.dart';
import 'package:eservices/home/announcement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent/android_intent.dart';


class Homepage extends StatefulWidget {
  final FirebaseUser currentUser;
  Homepage({this.currentUser});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Can't get current location"),
              content:
                  const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Enable GPS'),
                  onPressed: () {
                    final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
  
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    [Permission.microphone, Permission.storage,Permission.location].request();
    _checkGps();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: Image.asset('assets/images/profile.png'),
                  accountName: Center(
                    child:widget.currentUser == null? Text('Hi User',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),): Text(
                      'Hi ${widget.currentUser.displayName}',
                    ),
                  ),
                  accountEmail:widget.currentUser == null? null:Text(
                      widget.currentUser.phoneNumber
                    ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
               ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('About us'),
                onTap: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AboutUs()));
                },
              ),
              Divider(),
               ListTile(
                leading: Icon(Icons.volume_up),
                title: Text('Announcements'),
                onTap: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AnnounceMents()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.mail_outline),
                title: Text('Contact Us'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.star_half),
                title: Text('Share our App'),
                onTap: () {},
              ),
              Divider(),              
              ListTile(
                leading: widget.currentUser == null
                    ? Icon(Icons.person):
                    Icon(Icons.exit_to_app),
                title:
                    widget.currentUser == null ? Text('Login/signup') : 
                    Text('LogOut'),
                onTap: (){
                  widget.currentUser == null
                      ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage())):
                    AuthService().signOut();
                },
              ),
              
              Divider(),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Dhanamuthra People Service'),
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('mainservices')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  children: <Widget>[
                    Container(
                      height: 75,
                      child: InkWell(
                        onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Deals(user: widget.currentUser,)));
                        },
                       child: Card(
                         elevation:2.0,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.local_offer,
                                size: 20.0,),
                                Text("Todays Deals",
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize:20.0,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ],
                            ),),
                        ),
                      ),
                    ),
                    Container(
                        height: 280,
                        child: Image.asset('assets/images/banner.jpeg',
                  fit: BoxFit.cover)
                      ),
                    GridView.builder(
                       physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          DocumentSnapshot data =
                              snapshot.data.documents[index];
                          return Column(
                            children: <Widget>[
                              Container(
                                height: 150,
                                width: 250,
                                child: InkWell(
                                  onTap: (){
                                     Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ServicePage(name: data,service: data['name'],currrentUser: widget.currentUser,)));
                                  },
                                                                        child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                      child: Image.network(
                                        data['image'],
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              Container(child: Text(data['name']))
                            ],
                          );
                        }),
                  ],
                );
              }
            }),
      ),
    );
  }
}
