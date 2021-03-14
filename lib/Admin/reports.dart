import 'package:eservices/reports/yearlyreport.dart';
import 'package:flutter/material.dart';


class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>{

  last(){
     CalendarDatePicker(
                  initialDate: DateTime(1999), firstDate: DateTime(1999), lastDate: DateTime.now(),
                  onDateChanged: (value) {
                    setState(() {
                      lastdate = value.toString().substring(0,11);
                      
                    });
                  });
  }
  var initialdate;
  var lastdate;
  @override
  Widget build(BuildContext context) {
   
        return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Reports'),
          ),
          body: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Select your Start Date'),
                ),
              ),
              Container(
                child:CalendarDatePicker(
                  initialDate: DateTime.now(), firstDate: DateTime(1999), lastDate: DateTime.now(),
                   onDateChanged:(value){
                     setState(() {
                       initialdate = value.toString().substring(0,11);
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> SecondPage(initialdate: initialdate,)));
                     });
                   } )
              ),
            ],
          )
        )
      );
  }
}


class SecondPage extends StatefulWidget {
  final initialdate;
  SecondPage({this.initialdate});
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  var lastdate;
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Reports'),
          ),
          body: Column(
            children: <Widget>[
               Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Select your end Date'),
                ),
              ),
              Container(
                child:CalendarDatePicker(
                  initialDate: DateTime.now(), firstDate: DateTime(1999), lastDate: DateTime.now(),
                   onDateChanged:(value){
                     setState(() {
                       lastdate = value.toString().substring(0,11);
                     });
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> YearlyReports(initial: widget.initialdate,last: lastdate,)));
                   } )
              ),
            ],
          )
        )
      );
  }
}
