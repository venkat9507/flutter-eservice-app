import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eservices/reports/subcategory.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  final DocumentSnapshot maindoc;
   final name;
  CategoryPage({this.name,this.maindoc});
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('select category'),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('mainservices').document(widget.maindoc.documentID).collection('services').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot categories =
                        snapshot.data.documents[index];
                    return Container(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> SubCategoryPage(name: categories['name'],)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/categorycard.png',
                                color: (index % 2 == 0)
                                    ? Colors.amber
                                    : Colors.red,
                              ),
                              Center(
                                child: Text(
                                  categories['name'],
                                  style: GoogleFonts.oswald(
                                    textStyle: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
