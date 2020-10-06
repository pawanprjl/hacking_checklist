import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacking_checklist/core/Drawer.dart';
import 'package:hacking_checklist/database/model/MyCategories.dart';
import 'package:hacking_checklist/database/repositories/CategoryRepository.dart';
import 'package:hacking_checklist/view/pages/target_page.dart';
import 'package:hacking_checklist/view/widgets/app_bar.dart';

class CategoryPage extends StatefulWidget {
  @override
  CategoryState createState() => new CategoryState();
}

class CategoryState extends State<CategoryPage> {
  final _categories = [];
  var _tapPosition;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _categoryController = TextEditingController();

  CategoryRepository _categoryRepository;

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
                _showDialogBox("Edit Category", "Edit", _categories[index]);
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
    _asyncInitState();
  }

  _asyncInitState() async {
    Future<List<MyCategory>> myCategories =
        _categoryRepository.getAllCategories();
    myCategories.then((myCategories) {
      for (MyCategory _category in myCategories) {
        _categories.add(_category.category);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 100.0),
          child: CustomTitleBar('Category', _scaffoldKey, false),
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
    if (_categories.length == 0) {
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
        itemCount: _categories.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTapDown: _storePosition,
            onLongPress: () => _showCustomMenu(index),
            child: _showItem(_categories[index]),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => TargetPage(_item)));
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
            _showDialogBox("Add Category", "Add", "");
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
    _categoryController.text = _controllerValue;

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
                    controller: _categoryController,
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
      _categoryRepository
          .addCategory(new MyCategory(_categoryController.text))
          .then((value) {
        setState(() {
          _categories.add(_categoryController.text);
        });
        Navigator.of(context).pop(true);
      });
    } else {
      MyCategory myCategory = await _categoryRepository.getCategoryByName(categoryName: _controllerValue);
      myCategory.category = _categoryController.text;
      await _categoryRepository.updateCategory(myCategory).then((value) {
        _categories[_categories.indexOf(_controllerValue)] = _categoryController.text;
        setState(() {});
        Navigator.of(context).pop(true);
      });
    }
  }

  _showAlertDialogBox(index){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Delete ${_categories[index]}',
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
                'Are you sure to delete this category ?',
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
                        _categoryRepository.deleteCategory(_categories[index]).then((value) {
                          setState(() {
                            _categories.removeAt(index);
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
