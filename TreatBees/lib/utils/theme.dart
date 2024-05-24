import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MyColors {
  Color primary = Colors.orangeAccent;
  Color alice = Color.fromRGBO(247, 252, 255, 1);
  Color shadowLight = Color.fromRGBO(243, 250, 255, 1);
  Color shadowDark = Color.fromRGBO(218, 225, 233, 1);
}

class MyFonts {
  TextStyle headingBold = new TextStyle(
      color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold);
  TextStyle headingLight = new TextStyle(
      color: Colors.black, fontSize: 30, fontWeight: FontWeight.w300);

  TextStyle smallHeadingBold = new TextStyle(
      color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold);
  TextStyle smallHeadingLight = new TextStyle(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300);
}
