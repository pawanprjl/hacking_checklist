import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacking_checklist/database/model/MyChecklist.dart';
import 'package:hacking_checklist/database/repositories/ChecklistRepository.dart';
import 'package:hacking_checklist/database/repositories/TargetRepository.dart';
import 'package:hacking_checklist/view/widgets/app_bar.dart';

class ChecklistPage extends StatefulWidget {
  final String _title;

  ChecklistPage(this._title);

  @override
  ChecklistState createState() => new ChecklistState(this._title);
}

class ChecklistState extends State<ChecklistPage> {
  final String _title;

  ChecklistState(this._title);

  MyChecklist _myChecklist;

  var _checklists = [];
  int _targetId;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ChecklistRepository _checklistRepository;
  TargetRepository _targetRepository;

  @override
  void initState() {
    super.initState();
    _checklistRepository = new ChecklistRepository();
    _targetRepository = new TargetRepository();
    _asyncInitState();
  }

  _asyncInitState() async {
    _targetRepository.getTargetByName(targetName: _title).then((onValue) {
      _targetId = onValue.id;
      _checklistRepository.getChecklistsOfTarget(_targetId).then((checklists) {
        for (MyChecklist checklist in checklists) {
          _checklists.add(checklist);
        }
        setState(() {});
        if (_checklists.length == 0) {
          _loadChecklistFromFile().then((value) async {
            for (String line in value){
              _myChecklist = new MyChecklist(line, 0, _targetId);
              await _checklistRepository.addChecklist(new MyChecklist(line, 0, _targetId)).then((value){
                _checklists.add(_myChecklist);
                setState(() {});
              });
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 100.0),
          child: CustomTitleBar(_title, _scaffoldKey, true),
        ),
        body: Container(
          color: Color(0xff0f3057),
          constraints: BoxConstraints.expand(),
          child: _showList(),
        ),
      ),
    );
  }

  Widget _showList() {
    if (_checklists.length == 0) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.all(15.0),
      child: ListView.builder(
        itemCount: _checklists.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            child: _showItem(_checklists[index]),
          );
        },
      ),
    );
  }

  Widget _showItem(MyChecklist checklist) {
    return Container(
      child: new Row(
        children: <Widget>[
          Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                  value: _checklistIntToBool(checklist.status),
                  tristate: false,
                  onChanged: (value) {
                    _checklistValueChangedHandler(value, checklist);
                  })),
          Text(
            checklist.taskName,
            style: GoogleFonts.lemonada(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  bool _checklistIntToBool(int value) {
    if (value == 0) {
      return false;
    } else {
      return true;
    }
  }

  int _checklistBoolToInt(bool value) {
    if (value) {
      return 1;
    }else {
      return 0;
    }
  }

  _checklistValueChangedHandler(bool value, MyChecklist checklist) {
    checklist.status = _checklistBoolToInt(value);
    _checklistRepository.updateChecklist(checklist).then((value) {
      setState(() {});
    });
  }

  Future<List<String>> _loadChecklistFromFile() async {
    List<String> checklists = [];
    await rootBundle.loadString('assets/file/checklist.txt').then((value) {
      for (String line in LineSplitter().convert(value)){
        checklists.add(line);
      }
    });
    return checklists;
  }
}
