import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body:ListView(
            children: <Widget>[
              Container(
                child:Image.asset('assets/images/launch_image.jpeg',
                fit: BoxFit.cover)
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Loading...',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              )
            ],
          )),
    );
  }
}