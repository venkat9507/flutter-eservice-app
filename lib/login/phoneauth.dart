import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eservices/Admin/AdminHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eservices/home/homepage.dart';
import 'package:eservices/login/login.dart';

class AuthService {
  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser>snapshot) {
       return snapshot.hasData?
       snapshot.data.phoneNumber == '+919790077956'||snapshot.data.phoneNumber == '+917502067869'?AdminHome(currentUser: snapshot.data,):
       Homepage(currentUser:snapshot.data):
       LoginPage();
        });
  }

  //Sign out
  signOut() async{
    await FirebaseAuth.instance.signOut();
    // user = await FirebaseAuth.instance.currentUser();
  }

  //SignIn
signIn({AuthCredential authCreds, String name, String phone}) async{
    await FirebaseAuth.instance.signInWithCredential(authCreds);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName=name;
    user.updateProfile(updateInfo);
    await Firestore.instance.collection('users').document(user.uid).setData({'name':name, 'phone':phone});
  }

  signInWithOTP(smsCode, verId,String name, String phone, BuildContext context) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds:authCreds,name:name,phone:phone);
 
  }
   Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error Message'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }
}