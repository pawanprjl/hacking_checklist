import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTitleBar extends StatelessWidget {

  final String _title;
  final bool _isBackIconPresent;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  CustomTitleBar(this._title, this._scaffoldKey, this._isBackIconPresent);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 110.0,
      color: Color(0xff0f3057),
      child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _backIcon(context),
              _appTitle(),
              _drawerButton(),
            ],
          )),
    );
  }

  Widget _backIcon(BuildContext context){
    if(!_isBackIconPresent){
      return Container(height: 0.0, width: 0.0,);
    }

    return new IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  Widget _appTitle() {
    return Expanded(
      child: Text(
        _title,
        style: GoogleFonts.lemonada(
          fontSize: 24.0,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _drawerButton() {
    return IconButton(
      icon: Icon(Icons.menu, color: Colors.white,),
      onPressed: () { _scaffoldKey.currentState.openEndDrawer();},
    );
  }
}
