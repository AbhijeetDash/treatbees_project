import 'package:flutter/material.dart';
import 'package:treatbees/layout/web.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024 && constraints.maxHeight >= 768) {
          return WebHome();
        }
        if (constraints.maxWidth >= 768 && constraints.maxHeight >= 1024) {
          return WebHome();
        }
        // if (constraints.maxWidth <= 768) {
        //   return Container();
        // }
        return WebHome();
      },
    );
  }
}
