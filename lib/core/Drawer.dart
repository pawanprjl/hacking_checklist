import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacking_checklist/view/pages/DetailsPage.dart';
import 'package:hacking_checklist/view/pages/categories_page.dart';
import 'package:hacking_checklist/view/pages/methodologies.dart';

myDrawer(context){
  return Drawer(
    child: Container(
      color: Color(0xff0f3057),
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Container(
                width: 130.0,
                height: 130.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/icon.png')
                    )
                ),
              ),
            ),
          ),
          ListTile(
            title: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage()));
              },
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Color(0xff0f3057),
              padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Icon(Icons.keyboard_arrow_left, color: Colors.white,),
                  new Container(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Targets',
                      style: GoogleFonts.lemonada(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
              },
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Color(0xff0f3057),
              padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Icon(Icons.keyboard_arrow_left, color: Colors.white,),
                  new Container(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Categories',
                      style: GoogleFonts.lemonada(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Methodology()));
              },
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Color(0xff0f3057),
              padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Icon(Icons.keyboard_arrow_left, color: Colors.white,),
                  new Container(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Methodologies',
                      style: GoogleFonts.lemonada(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}