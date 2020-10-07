import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacking_checklist/core/Drawer.dart';
import 'package:hacking_checklist/database/model/MyTargets.dart';
import 'package:hacking_checklist/database/repositories/CategoryRepository.dart';
import 'package:hacking_checklist/database/repositories/TargetRepository.dart';
import 'package:hacking_checklist/view/pages/categories_page.dart';
import 'package:hacking_checklist/view/pages/checklist_page.dart';
import 'package:hacking_checklist/view/widgets/app_bar.dart';

class DetailPage extends StatefulWidget{
  @override
  DetailPageState createState() => new DetailPageState();
}

class DetailPageState extends State<DetailPage>{

  final _detailsList = [];

  TargetRepository _targetRepository;
  CategoryRepository _categoryRepository;
  var _tapPosition;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  TextEditingController targetNameController = TextEditingController();

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
                Navigator.of(context).pop();
                _showDeleteDialogBox(index);
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
                _showEditDialogBox(_detailsList[index].targetName, index);
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


  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: Text(
          'Are you sure ?',
          style: GoogleFonts.lemonada(
            color: Color(0xff0f3057),
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: Text(
                'Do you want to exit app?',
                style: GoogleFonts.lemonada(
                  color: Color(0xff0f3057),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                ),
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
                        exit(0);
                      },
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
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


  @override
  void initState() {
    super.initState();
    _categoryRepository = new CategoryRepository();
    _targetRepository = new TargetRepository();
    _asyncInitState();

  }

  _asyncInitState() async {
      _targetRepository.getAllTargets().then((targets) async {
        for (MyTarget target in targets){
            await _categoryRepository.getCategoryById(target.categoryId).then((category) {
              _detailsList.add(new DetailHolder(target.targetName, category.category));
            });
            setState(() {});
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size(40.0, 100.0),
          child: CustomTitleBar('Details', _scaffoldKey, false),
        ),
        body: Container(
          color: Color(0xff0f3057),
          constraints: BoxConstraints.expand(),
          child: _showList(),
        ),
        endDrawer: myDrawer(context),
        floatingActionButton: _myFloatingButton(),
      ),
    );
  }

  Widget _showList() {
    if(_detailsList.length == 0){
      return Container(
        padding: EdgeInsets.only(bottom: 100.0),
        child: Center(
          child: Text(
            'No targets available !',
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
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(20.0),
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        children: List.generate(
            _detailsList.length, (index) => GestureDetector(
          onTapDown: _storePosition,
          onLongPress: () => _showCustomMenu(index),
          child: _showItem(_detailsList[index]),
        ),
        ),
      ),
    );
  }

  Widget _showItem(DetailHolder detailHolder){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
      child: SizedBox(
        height: 80.0,
        child: RaisedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistPage(detailHolder.targetName)));
          },
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Color(0xff0f3057),
          padding: EdgeInsets.only(
            left: 25.0, right: 25.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  detailHolder.targetName,
                  style: GoogleFonts.lemonada(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  detailHolder.targetCategory,
                  style: GoogleFonts.lemonada(
                    color: Colors.white70,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myFloatingButton(){
    return Container(
      height: 75.0,
      width: 75.0,
      padding: EdgeInsets.all(5.0),
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            _showAddDialogBox();
          },
          child: Icon(
            Icons.add,
            color:Colors.white,
            size: 32.0,
          ),
          backgroundColor: Color(0xff0f3057),
        ),
      ),
    );
  }

  _showAddDialogBox(){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Are you sure?',
          style: GoogleFonts.lemonada(
            fontSize: 24.0,
            color: Color(0xff0f3057),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Align(
              alignment: Alignment.center,
              child: Text(
                'You will be redirected to categories page for adding target!',
                textAlign: TextAlign.center,
                style: GoogleFonts.lemonada(
                  color: Color(0xff0f3057),
                ),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    height: 40.0, width: 100.0,
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
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    height: 40.0, width: 100.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
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

  _showEditDialogBox(String _targetControllerValue, int index){
    targetNameController.text = _targetControllerValue;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit $_targetControllerValue',
          style: GoogleFonts.lemonada(
            fontSize: 24.0,
            color: Color(0xff0f3057),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: TextFormField(
                maxLines: 1,
                cursorColor: Color(0xff0f3057),
                cursorWidth: 1.0,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                controller: targetNameController,
                decoration: new InputDecoration(
                  hintText: 'Category',
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
                        if(_formKey.currentState.validate()){
                          _formKey.currentState.save();
                          _targetRepository.getTargetByName(targetName: _targetControllerValue).then((target) {
                            target.targetName = targetNameController.text;
                            _targetRepository.updateTarget(target).then((onValue) {
                              _detailsList[index].targetName = targetNameController.text;
                              setState(() {});
                              Navigator.of(context).pop();
                            });
                          });
                        }else {
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
                        'Edit',
                        style: GoogleFonts.lemonada(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showDeleteDialogBox(index){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Delete ${_detailsList[index].targetName}',
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
                        _targetRepository.deleteTarget(_detailsList[index].targetName).then((value) {
                          setState(() {
                            _detailsList.removeAt(index);
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

class DetailHolder {
  String targetName;
  String targetCategory;

  DetailHolder(this.targetName, this.targetCategory);
}