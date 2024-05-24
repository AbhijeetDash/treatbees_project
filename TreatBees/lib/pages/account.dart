import 'dart:async';

import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/pages/userDetails.dart';
import 'package:TreatBees/utils/functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController fadeController;
  Animation anim;
  SharedPreferences sp;
  Widget button = Container();

  @override
  void initState() {
    drive();
    checkUser();
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Hero(
                    tag: "Logo",
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(text: 'Treat', style: MyFonts().headingBold),
                        TextSpan(text: 'Bees', style: MyFonts().headingLight),
                        TextSpan(text: '\nParas Tierea', style: MyFonts().smallHeadingLight),
                      ]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                FadeTransition(
                  opacity: anim,
                  child: SizedBox(
                      width: width * 0.7,
                      child: Text(
                        '',
                        textAlign: TextAlign.center,
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
                FadeTransition(
                  opacity: anim,
                  child: button,
                )
              ],
            ),
            Positioned(
                bottom: -80,
                right: -50,
                child: Hero(
                  tag: "Icon",
                  child: Container(
                      width: width,
                      height: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/foodIllus.png')))),
                ))
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User> signIn() async {
    Firebase.initializeApp();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    FirebaseAnalytics().logSignUp(signUpMethod: "Google-SignIn");
    return user;
  }

  Future<User> loginIn() async {
    if (await googleSignIn.isSignedIn()) {
      FirebaseAnalytics().logLogin();
    }
    return _auth.currentUser;
  }

  void drive() {
    fadeController = new AnimationController(
        duration: Duration(milliseconds: 400), vsync: this);
    anim = new Tween(begin: 0.0, end: 1.0).animate(fadeController);
    Timer(Duration(milliseconds: 500), () {
      fadeController.forward();
    });
  }

  Future<void> checkUser() async {
    sp = await SharedPreferences.getInstance();
    if (sp.getBool('available') == null) {
      setState(() {
        button = SizedBox(
          height: 60,
          width: 150,
          child: Container(
            decoration: BoxDecoration(
                color: MyColors().alice,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: MyColors().shadowDark,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15,
                      spreadRadius: 1),
                  BoxShadow(
                      color: MyColors().shadowLight,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 15,
                      spreadRadius: 1)
                ],
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      MyColors().shadowDark,
                      MyColors().alice,
                    ])),
            child: RawMaterialButton(
                splashColor: Colors.white.withOpacity(0.6),
                shape: StadiumBorder(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/g.png'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Text(
                        "Sign-in",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    button = Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.orange),
                        ),
                      ),
                    );
                  });
                  signIn().then((value) {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (a, b, c) {
                        return UserDetails(
                          sp: sp,
                          user: value,
                          fromOrderPage: false,
                        );
                      },
                      transitionDuration: Duration(milliseconds: 500),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        animation = CurvedAnimation(
                            curve: Curves.ease, parent: animation);
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ));
                  });
                }),
          ),
        );
      });
    } else {
      setState(() {
        button = Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.orange),
            ),
          ),
        );
        Timer(Duration(seconds: 2), () {
          loginIn().then((value) {
            FirebaseCallbacks().getCurrentUser(value.email).then((val) => {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (a, b, c) {
                      return Home(
                        sp: null,
                        user: value,
                        phone: val['userPhone'],
                        msgToken: val['msgToken'],
                      );
                    },
                    transitionDuration: Duration(milliseconds: 500),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      animation = CurvedAnimation(
                          curve: Curves.ease, parent: animation);
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ))
                });
          });
        });
      });
    }
  }
}
