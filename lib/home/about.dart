import 'package:flutter/material.dart';
class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('About Us'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text('Ábout Us page'),
        ),
      ),
    );
  }
}