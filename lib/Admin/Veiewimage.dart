import 'package:flutter/material.dart';
class ViewPrescription extends StatefulWidget {
  final String url;
  ViewPrescription({this.url});
  @override
  _ViewPrescriptionState createState() => _ViewPrescriptionState();
}

class _ViewPrescriptionState extends State<ViewPrescription> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              height: MediaQuery.of(context).size.height-50,
              width: MediaQuery.of(context).size.height-50,
              child:Image.network(widget.url)
            ),
          ),
        )
      ),
    );
  }
}