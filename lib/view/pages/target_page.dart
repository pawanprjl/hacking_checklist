import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacking_checklist/core/Drawer.dart';
import 'package:hacking_checklist/database/model/MyTargets.dart';
import 'package:hacking_checklist/database/repositories/CategoryRepository.dart';
import 'package:hacking_checklist/database/repositories/TargetRepository.dart';
import 'package:hacking_checklist/view/pages/checklist_page.dart';
import 'package:hacking_checklist/view/widgets/app_bar.dart';

class TargetPage extends StatefulWidget {
  final String _title;

  // constructor
  TargetPage(this._title);

  @override
  TargetState createState() => new TargetState(this._title);
}

class TargetState extends State<TargetPage> {
  final String _title;

  // constructor
  TargetState(this._title);

  final _targets = [];
  var _tapPosition;
  var _categoryId;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  TextEditingController _targetController = TextEditingController();

  CategoryRepository _categoryRepository;
  TargetRepository _targetRepository;

  void _showCustomMenu(index) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    showMenu(
        context: context,
        position: RelativeRect.fromRect(
            _tapPosition & Size(40, 40), Offset.zero & overlay.size),
        items: <PopupMenuEntry>[
          PopupMenuItem(
            value: index,
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              onPressed: () {
                Navigator.of(context).pop(false);
                _showAlertDialogBox(index);
              },
              child: Row(
                children: [
                  Icon(Icons.delete),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Delete',
                      style: GoogleFonts.lemonada(
                        fontWeight: FontWeight.w300,
                        color: Color(0xff0f3057),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuItem(
            value: index,
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              onPressed: () {
                Navigator.of(context).pop(false);
                _showDialogBox("Edit Target", "Edit", _targets[index]);
              },
              child: Row(
                children: [
                  Icon(Icons.delete),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Edit',
                      style: GoogleFonts.lemonada(
                        fontWeight: FontWeight.w300,
                        color: Color(0xff0f3057),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  void initState() {
    super.initState();
    _categoryRepository = new CategoryRepository();
    _targetRepository = new TargetRepository();
    _asyncInitState();
  }

  _asyncInitState() async {
    _categoryRepository.getCategoryByName(categoryName: _title).then((value) {
      _categoryId = value.id;
      Future<List<MyTarget>> myTargets =
          _targetRepository.getTargetsOfCategory(_categoryId);
      myTargets.then((targets) {
        for (MyTarget _target in targets) {
          _targets.add(_target.targetName);
        }
        setState(() {});
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
        floatingActionButton: _myFloatingButton(),
        endDrawer: myDrawer(context),
      ),
    );
  }

  Widget _showList() {
    if (_targets.length == 0) {
      return Container(
        padding: EdgeInsets.only(bottom: 100.0),
        child: Center(
          child: Text(
            'Press + to add categories !',
            style: GoogleFonts.lemonada(
              fontSize: 16.0,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(15.0),
      child: ListView.builder(
        itemCount: _targets.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTapDown: _storePosition,
            onLongPress: () => _showCustomMenu(index),
            child: _showItem(_targets[index]),
          );
        },
      ),
    );
  }

  Widget _showItem(String _item) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
      child: SizedBox(
        height: 55.0,
        child: new RaisedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistPage(_item)));
          },
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          color: Color(0xff0f3057),
          padding: EdgeInsets.only(
            left: 25.0,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _item,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lemonada(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _myFloatingButton() {
    return Container(
      height: 75.0,
      width: 75.0,
      padding: EdgeInsets.all(5.0),
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            _showDialogBox("Add Target", "Add", "");
          },
          child: Icon(
            Icons.add,
            color: Color(0xff0f3057),
            size: 32.0,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  _showDialogBox(String _title, String _option, String _controllerValue) {
    _targetController.text = _controllerValue;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              _title,
              style: GoogleFonts.lemonada(
                fontSize: 18.0,
                color: Color(0xff0f3057),
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: new TextFormField(
                    maxLines: 1,
                    cursorColor: Color(0xff0f3057),
                    cursorWidth: 1.0,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    controller: _targetController,
                    decoration: new InputDecoration(
                      hintText: 'Target',
                      hintStyle: TextStyle(
                        color: Color(0xff008891),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff616466)),
                      ),
                    ),
                    style: GoogleFonts.lemonada(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff0f3057),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Can\'t be empty !' : null,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: 100.0,
                        height: 40.0,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Color(0xff0f3057),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.lemonada(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: 100.0,
                        height: 40.0,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _processDialogBox(_option, _controllerValue);
                            } else {
                              setState(() {
                                _autoValidate = true;
                              });
                            }
                          },
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Color(0xff0f3057),
                          child: Text(
                            _option,
                            style: GoogleFonts.lemonada(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _processDialogBox(String _option, String _controllerValue) async {
    if (_option == 'Add') {
      _targetRepository
          .addTarget(new MyTarget(_targetController.text, _categoryId))
          .then((value) {
        setState(() {
          _targets.add(_targetController.text);
        });
        Navigator.of(context).pop(true);
      });
    } else {
      MyTarget myTarget = await _targetRepository.getTargetByName(
          targetName: _controllerValue);
      myTarget.targetName = _targetController.text;
      await _targetRepository.updateTarget(myTarget).then((value) {
        _targets[_targets.indexOf(_controllerValue)] =
            _targetController.text;
        setState(() {});
        Navigator.of(context).pop(true);
      });
    }
  }

  _showAlertDialogBox(index) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Delete ${_targets[index]}',
          style: GoogleFonts.lemonada(
            fontSize: 18.0,
            color: Color(0xff0f3057),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              child: Text(
                'Are you sure to delete this target ?',
                textAlign: TextAlign.center,
                style: GoogleFonts.lemonada(
                  color: Color(0xff0f3057),
                ),
              ),
              alignment: Alignment.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Container(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: SizedBox(
                    width: 100.0,
                    height: 40.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Color(0xff0f3057),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.lemonada(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: SizedBox(
                    width: 100.0,
                    height: 40.0,
                    child: RaisedButton(
                      onPressed: () {
                        _targetRepository
                            .deleteTarget(_targets[index])
                            .then((value) {
                          setState(() {
                            _targets.removeAt(index);
                          });
                          Navigator.of(context).pop(true);
                        });
                      },
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Color(0xff0f3057),
                      child: Text(
                        'Ok',
                        style: GoogleFonts.lemonada(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
