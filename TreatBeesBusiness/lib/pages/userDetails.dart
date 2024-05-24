import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treatbees_business/pages/home.dart';
import 'package:treatbees_business/utils/functions.dart';
import 'package:treatbees_business/utils/theme.dart';

class CafeCode extends StatefulWidget {
  final User user;
  final SharedPreferences sp;
  const CafeCode({Key key, this.user, this.sp}) : super(key: key);
  @override
  _CafeCodeState createState() => _CafeCodeState();
}

class _CafeCodeState extends State<CafeCode> {
  TextEditingController controller;
  bool isPressed = true;
  String msgToken;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    controller = TextEditingController();
    firebaseMessaging.getToken().then((token) {
      setState(() {
        msgToken = token;
      });
    });
    isPressed = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: MyColors().alice,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Cafe info",
              style: MyFonts().headingBold,
            ),
            SizedBox(height: 10),
            Text(
              "Welcome to TreatBees Business\nPlease enter the cafe code that you\ngot from us.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter cafe code",
                ),
              ),
            ),
            SizedBox(height: 10),
            isPressed
                ? RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        isPressed = false;
                      });
                      if (controller.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Container(
                                width: width * 0.8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 15),
                                    Icon(Icons.error),
                                    SizedBox(height: 15),
                                    Text(
                                      'Enter the cafeCode that we sent you.\nIf you havent recieved one, our\nexecutive will contact you soon',
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        FirebaseCallbacks()
                            .verifyCafe(
                                controller.text, widget.user.email, msgToken)
                            .then((value) {

                              if(value){
                                showDialog(context: context,
                                    child: Dialog(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 10.0,),
                                            CircleAvatar(
                                              backgroundColor: Colors.green,
                                              child: Icon(Icons.done_all),
                                            ),
                                            SizedBox(height: 10.0),
                                            Text("Verification Complete", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                            SizedBox(height: 10.0),
                                            Text("Welcome to Treatbees business\nWe are glad to have you with us.", textAlign: TextAlign.center,),
                                            SizedBox(height: 10.0,),
                                            RawMaterialButton(
                                              shape: StadiumBorder(),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                              fillColor: Colors.orange,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Okay", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                              ),
                                            ),
                                            SizedBox(height: 10.0,),
                                          ],
                                        ),
                                      ),
                                    )
                                );

                                Timer(Duration(seconds: 2), () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                      builder: (context) => Home(
                                        sp: widget.sp,
                                        user: widget.user,
                                        code: controller.text,
                                        menu: false,
                                      )));
                                });

                              } else {
                                setState(() {
                                  isPressed = true;
                                });
                                showDialog(context: context,
                                    child: Dialog(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 10.0,),
                                            CircleAvatar(
                                              backgroundColor: Colors.red,
                                              child: Icon(Icons.close),
                                            ),
                                            SizedBox(height: 10.0),
                                            Text("Wrong Code", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                            SizedBox(height: 10.0),
                                            Text("Sorry, this code does not exists.", textAlign: TextAlign.center,),
                                            SizedBox(height: 10.0,),
                                            RawMaterialButton(
                                              shape: StadiumBorder(),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                              fillColor: Colors.orange,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Okay", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                              ),
                                            ),
                                            SizedBox(height: 10.0,),
                                          ],
                                        ),
                                      ),
                                    )
                                );
                              }
                        });
                      }
                    },
                    shape: StadiumBorder(),
                    fillColor: Colors.orange,
                    child: Text("JOIN"),
                  )
                : Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
