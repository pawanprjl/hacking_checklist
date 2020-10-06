import 'package:flutter/material.dart';
import 'package:hacking_checklist/view/pages/categories_page.dart';
import 'package:hacking_checklist/view/pages/checklist_page.dart';
import 'package:hacking_checklist/view/pages/methodologies.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacking Checklist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Methodology(),
    );
  }
}
