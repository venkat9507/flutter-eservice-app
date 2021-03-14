// import 'dart:async';

// import 'package:eservices/log/screens/wrapper.dart';
// import 'package:eservices/log/services/auth.dart';
// import 'package:eservices/splash.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:eservices/log/models/user.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
 
//   @override
//   Widget build(BuildContext context) {
//    return
//      StreamProvider<User>.value(
//       value: AuthService().user,
//       child: MaterialApp(
//         theme: ThemeData(
//         primaryColor: Colors.blue[700],
//         primarySwatch: Colors.blue,
//       ),
//         debugShowCheckedModeBanner: false,
//         home: 
//          Wrapper(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:eservices/login/phoneauth.dart';

void main() => runApp(MyApp()); 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuth(),
    );
  }
}