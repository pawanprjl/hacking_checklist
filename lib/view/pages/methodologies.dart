import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Methodology extends StatefulWidget{
  @override
  MethodologyState createState() => new MethodologyState();
}

class MethodologyState extends State<Methodology>{

  List<String> _tasks = [];
  var _tapPosition;
  int _subCategoryId;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            return Text(_tasks[index]);
          },
        ),
      ),
    );
  }
}