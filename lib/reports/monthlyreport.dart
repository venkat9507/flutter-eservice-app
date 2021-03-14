import 'package:eservices/reports/monthly.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MonthlyReports extends StatefulWidget {
  @override
  _MonthlyReportsState createState() => _MonthlyReportsState();
}

class _MonthlyReportsState extends State<MonthlyReports> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Monthly Reports'),
        ),
        body: Container(
            child: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: <Widget>[
            Container(
              height: 200.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month: 1,name: 'January',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'January',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.purple,
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: InkWell(
                 onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month: 2,name: 'February',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'February ',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.green,
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: InkWell(
                              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month: 3,name: 'March',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'March ',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.red,
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: InkWell(
                              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month: 4,name: 'April',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'April ',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.blueGrey,
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: InkWell(
                              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month: 5,name: 'May',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'May',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.amber,
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: InkWell(
                              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month: 6,name: 'June',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'June',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.lime,
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: InkWell(
                              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month: 7,name: 'July',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'July',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: InkWell(
                              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month: 8,name: 'August',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'August',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.pink,
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: InkWell(
                              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month: 9,name: 'September',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'September',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.orange,
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: InkWell(
                              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month:10,name: 'October',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'October',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.blue,
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: InkWell(
                              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month: 11,name: 'November',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'November',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 33.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.teal,
                ),
              ),
            ),
            Container(
              height: 200.0,
              child: InkWell(
                              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Monthly(month: 12,name: 'December',)));
                },
                              child: Card(
                  child: Stack(
                    children: [
                      Image.asset('assets/images/card.png'),
                      Center(
                        child: Text(
                          'December',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  color: Colors.brown,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
