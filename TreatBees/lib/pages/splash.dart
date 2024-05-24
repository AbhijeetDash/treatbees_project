import 'dart:async';

import 'package:TreatBees/pages/account.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController fadeController;
  Animation anim;

  @override
  void initState() {
    driver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: MyColors().alice,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(30),
                child: FadeTransition(
                  opacity: anim,
                  child: Hero(
                    tag: "Logo",
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(text: 'Treat', style: MyFonts().headingBold),
                        TextSpan(text: 'Bees', style: MyFonts().headingLight),
                        TextSpan(text: '\nParas Tierea', style: MyFonts().smallHeadingLight),
                      ]),
                    ),
                  ),
                )),
            Positioned(
              right: -50,
              child: FadeTransition(
                opacity: anim,
                child: Hero(
                  tag: "Icon",
                  child: Container(
                    width: width * 0.7,
                    height: 300,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/foodIllus.png'))),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void driver() {
    fadeController = new AnimationController(
        duration: Duration(milliseconds: 400), vsync: this);
    anim = new Tween(begin: 0.0, end: 1.0).animate(fadeController);
    Timer(Duration(milliseconds: 500), () {
      fadeController.forward().whenComplete(() => {
            Timer(Duration(milliseconds: 600), () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                  pageBuilder: (a, b, c) {
                    return Login();
                  },
                  transitionDuration: Duration(milliseconds: 400)));
            })
          });
    });
  }
}
