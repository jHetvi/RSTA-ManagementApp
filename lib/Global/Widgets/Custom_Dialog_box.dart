import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class CustomDialogBox extends StatefulWidget {
  final String title;
  final Widget button1;
  final Widget button2;

  const CustomDialogBox({this.title, this.button1, this.button2});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.padding),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context),
        ),
      ),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.only(
          left: Constants.padding,
          top: Constants.padding,
          right: Constants.padding,
          bottom: Constants.padding),
      margin: EdgeInsets.only(top: Constants.avatarRadius),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constants.padding),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(child: widget.button1),
          SizedBox(
            height: 20.0,
          ),
          Container(child: widget.button2),
        ],
      ),
    );
  }
}
