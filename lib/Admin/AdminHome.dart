import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eservices/Admin/Veiewimage.dart';
import 'package:eservices/Admin/announcement.dart';
import 'package:eservices/Admin/audio.dart';
import 'package:eservices/Admin/user.dart';
import 'package:eservices/admin/adminservice.dart';
import 'package:eservices/adminservices/newrequest.dart';
import 'package:eservices/adminservices/ongoing.dart';
import 'package:eservices/home/deals.dart';
import 'package:eservices/login/phoneauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:eservices/Admin/reports.dart';
import 'package:permission_handler/permission_handler.dart';
import 'history.dart';

class AdminHome extends StatefulWidget {
  final FirebaseUser currentUser;
  AdminHome({this.currentUser});
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final AuthService _auth = AuthService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    _firebaseMessaging.subscribeToTopic('admin');
    super.initState();
    _firebaseMessaging.configure(
      onMessage: ((message) {
        print(message['notification']['title']);
        return;
      }),
      onLaunch: ((message) {
        print(message['notification']['title']);
        return;
      }),
      onResume: ((message) {
        print(message['notification']['title']);
        return;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Center(
                    child: Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  accountEmail: null),
              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Services'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminService()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.announcement),
                title: Text('Announcements'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AnnounceMents()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.local_offer),
                title: Text('Hot Deals'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Deals(
                                user: widget.currentUser,
                              )));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Reports'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportsPage(),
                      ));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Users'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserData()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('History'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HistoryPage()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.mic),
                title: Text('Delete Audios'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Audiopage()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('logOut'),
                onTap: () async {
                  await _auth.signOut();
                },
              ),
              Divider(),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Hello Admin'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  StreamBuilder(
                    stream: Firestore.instance
                        .collection('requests')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'New Requests',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  CircleAvatar(
                                      radius: 12,
                                      child: Text(snapshot.data.documents.length
                                          .toString()))
                                ],
                              ),
                            ),
                            Container(
                              height: 300.0,
                              child: Card(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: snapshot.data.documents.length ==
                                            0
                                        ? 0
                                        : snapshot.data.documents.length == 1
                                            ? 1
                                            : 2,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot req =
                                          snapshot.data.documents[index];
                                      String url = req['services'];
                                      String prescription = req['prescription'];
                                      return Slidable(
                                        actionPane: SlidableBehindActionPane(),
                                        actionExtentRatio: 0.30,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Text(
                                                  'Name : ${req['name']}',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                Text(
                                                  'Phone No : ${req['phone']}',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                Text(
                                                  'Category : ${req['service_name']}',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                Text(
                                                  'Time : ${req['time']}',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                req['service'] != null
                                                    ? Text(
                                                        'Service Name : ${req['service']}',
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                        ),
                                                      )
                                                    : req['prescription'] !=
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
                                                        : PlayAudio(url: url)
                                              ],
                                            ),
                                          ),
                                        ),
                                        secondaryActions: <Widget>[
                                          IconSlideAction(
                                              caption: 'Move to Ongoing',
                                              color: Colors.green,
                                              icon: Icons.exit_to_app,
                                              onTap: () async {
                                                Firestore.instance
                                                    .collection('requests')
                                                    .document(req.documentID)
                                                    .delete();
                                                req['services'] == null
                                                    ? await Firestore.instance
                                                        .collection('ongoing')
                                                        .add({
                                                        "name": req['name'],
                                                        "phone": req['phone'],
                                                        "service_name":
                                                            req['service_name'],
                                                        "service":
                                                            req['service'],
                                                        'time': req['time'],
                                                        'date': req['date'],
                                                        'month': req['month'],
                                                        'year': req['year']
                                                      })
                                                    : await Firestore.instance
                                                        .collection('ongoing')
                                                        .add({
                                                        "name": req['name'],
                                                        "phone": req['phone'],
                                                        "service_name":
                                                            req['service_name'],
                                                        "services":
                                                            req['services'],
                                                        'time': req['time'],
                                                        'date': req['date'],
                                                        'month': req['month'],
                                                        'year': req['year']
                                                      });
                                              })
                                        ],
                                      );
                                    }),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: 15.0),
                  FloatingActionButton.extended(
                    heroTag: Text('btn'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewRequest()));
                    },
                    label: Text('View All'),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  StreamBuilder(
                    stream: Firestore.instance
                        .collection('ongoing')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Ongoing Requests',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  CircleAvatar(
                                      radius: 12,
                                      child: Text(snapshot.data.documents.length
                                          .toString()))
                                ],
                              ),
                            ),
                            Container(
                              height: 300.0,
                              child: Card(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: snapshot.data.documents.length ==
                                            0
                                        ? 0
                                        : snapshot.data.documents.length == 1
                                            ? 1
                                            : 2,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot req =
                                          snapshot.data.documents[index];
                                      String url = req['services'];
                                      return Slidable(
                                        actionPane: SlidableBehindActionPane(),
                                        actionExtentRatio: 0.30,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Text(
                                                  'Name : ${req['name']}',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                Text(
                                                  'Phone No : ${req['phone']}',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                Text(
                                                  'Time : ${req['time']}',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                req['service'] != null
                                                    ? Text(
                                                        'Service Name : ${req['service']}',
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                        ),
                                                      )
                                                    : PlayAudio(
                                                        url: url,
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                        secondaryActions: <Widget>[
                                          IconSlideAction(
                                              caption: 'Move to Completed',
                                              color: Colors.green,
                                              icon: Icons.exit_to_app,
                                              onTap: () async {
                                                Firestore.instance
                                                    .collection('ongoing')
                                                    .document(req.documentID)
                                                    .delete();
                                                req['services'] == null
                                                    ? await Firestore.instance
                                                        .collection('completed')
                                                        .add({
                                                        "name": req['name'],
                                                        "phone": req['phone'],
                                                        "service_name":
                                                            req['service_name'],
                                                        "service":
                                                            req['service'],
                                                        'time': req['time'],
                                                        'date': req['date'],
                                                        'month': req['month'],
                                                        'year': req['year']
                                                      })
                                                    : await Firestore.instance
                                                        .collection('completed')
                                                        .add({
                                                        "name": req['name'],
                                                        "phone": req['phone'],
                                                        "service_name":
                                                            req['service_name'],
                                                        "services":
                                                            req['services'],
                                                        'time': req['time'],
                                                        'date': req['date'],
                                                        'month': req['month'],
                                                        'year': req['year']
                                                      });
                                              })
                                        ],
                                      );
                                    }),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: 15.0),
                  FloatingActionButton.extended(
                    heroTag: Text('btn'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnGoingRequest()));
                    },
                    label: Text('View All'),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  StreamBuilder(
                    stream: Firestore.instance
                        .collection('completed')
                        .orderBy('time')
                        .limit(2)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: 300.0,
                              child: Card(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot req =
                                          snapshot.data.documents[index];
                                      String url = req['services'];
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Text(
                                                'Name : ${req['name']}',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Text(
                                                'Phone No : ${req['phone']}',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Text(
                                                'Time : ${req['time']}',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              req['service'] != null
                                                  ? Text(
                                                      'Service Name : ${req['service']}',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                      ),
                                                    )
                                                  : PlayAudio(
                                                      url: url,
                                                    )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: 15.0),
                  FloatingActionButton.extended(
                    heroTag: Text('btn'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HistoryPage()));
                    },
                    label: Text('View All'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
