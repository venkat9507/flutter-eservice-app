import 'package:eservices/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eservices/login/phoneauth.dart';

class LoginPage extends StatefulWidget {
  final bool hasdata;
  LoginPage({this.hasdata=false});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  bool _isLoading = false;
  String phoneNo, verificationId, smsCode,name;
  bool codeSent = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
        body: ListView(
          children: <Widget>[
             Stack(
               children: <Widget>[
                 Container(
                   width: MediaQuery.of(context).size.width-20,
                   child: Image.asset('assets/images/logo.jpg',
                   fit: BoxFit.cover,),
                 ),
                widget.hasdata?
                Positioned(
                   right: 0.5,
                   child:
                  Column(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage()),);
                          
                        },
                        icon: Icon(Icons.home),
                      ),
                      Text('HOME')
                    ],
                  ),):
                  Positioned(
                    right: 0.5,
                      child: FlatButton(onPressed: (){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage()),);
                    }, child: Text('Skip',
                    style: TextStyle(
                      fontSize:17.0,
                    ),)),
                  )
               ],
             ),
             Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(41),
                        child: Text(
                          'Login with your credentials',
                          style: TextStyle(
                              fontSize: 25),
                        )),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Sign in',
                          style: TextStyle( 
                          fontSize: 30),
                        )),
            Container(
               padding: EdgeInsets.all(10),
              child: Form( 
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                       TextFormField(
                         autofocus: true,
                       decoration: InputDecoration(
                                             border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(35.0),
                                            ),
                                    labelText: 'Name',
                                    prefixIcon: Icon(Icons.person, color: Colors.black,),
                                  ),
                      validator: (val) => val.isEmpty ? 'Please enter your Name' : null,
                      onSaved: (val) => name = val
                    ),
                    SizedBox(height:20),
                      TextFormField(
                        initialValue: '+91',
                       decoration: InputDecoration(
                                   border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone, color: Colors.black,),
                        ),
                      keyboardType: TextInputType.phone,
                      validator: (val) => val.isEmpty ? 'Please enter your Phone Number' : null,
                      onSaved: (val) => phoneNo = val,
                       ), SizedBox(height: 20.0),
                          codeSent ? TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              suffix: FlatButton(onPressed: ()=>verifyPhone(phoneNo), child: Text('Resend OTP')),
                              hintText: 'Enter OTP'),
                            onChanged: (val) {
                              setState(() {
                                this.smsCode = val;
                              });
                            },
                          ) : Container(),
                           SizedBox(height: 20.0),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child:FloatingActionButton.extended(
                            label: codeSent ? Text('Verify'):Text('Send OTP'),
                            onPressed: () async{
                              final form = formKey.currentState;
                              form.save();
                              if(form.validate()){
                              setState(() {
                                _isLoading = true;
                              });
                              if(codeSent == true){
                                   AuthService().signInWithOTP(smsCode, verificationId,name,phoneNo,context);
                                   widget.hasdata==true??Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage()));
                                   setState(() {
                                     _isLoading = false;
                                   });
                                  
                                 }
                                 else{
                                   
                                 if(_isLoading==true){
                                     verifyPhone(phoneNo);
                                   }
                                   _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                     duration: Duration(seconds: 8),
                                   content: new Text('Please Wait...'),),);
                             }
                            }}),
                      ),
                      SizedBox(height: 20,),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
  Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
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
      context: context,
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authCreds: authResult,phone: phoneNo, name: name);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      return _buildErrorDialog(context, authException.message);
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 45),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
