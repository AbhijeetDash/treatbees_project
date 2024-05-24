import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/utils/functions.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails extends StatefulWidget {
  final User user;
  final SharedPreferences sp;
  final bool fromOrderPage;
  const UserDetails({Key key, this.user, this.sp, this.fromOrderPage})
      : super(key: key);
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController controller;
  TextEditingController _adsL1;
  TextEditingController _adsL2;
  TextEditingController _city;
  TextEditingController _pinCode;
  bool isPressed = true;
  String msgToken;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    controller = TextEditingController();
    _adsL1 = TextEditingController();
    _adsL2 = TextEditingController();
    _city = TextEditingController();
    _pinCode = TextEditingController();
    isPressed = true;
    firebaseMessaging.getToken().then((token) {
      setState(() {
        msgToken = token;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          width: width,
          height: height,
          color: MyColors().alice,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Contact info",
                  style: MyFonts().headingBold,
                ),
                SizedBox(height: 10),
                Text(
                  "We would need your contact information\nto provide you order updates.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Your Phone Number",
                    ),
                    validator: (val) {
                      return val.isEmpty ? "This is Required" : null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                    controller: _adsL1,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Flat/House no.",
                    ),
                    validator: (val) {
                      return val.isEmpty ? "This is Required" : null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                    controller: _adsL2,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Landmark/Society/Area",
                    ),
                    validator: (val) {
                      return val.isEmpty ? "This is Required" : null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                    controller: _city,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "City",
                    ),
                    validator: (val) {
                      return val.isEmpty ? "This is Required" : null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                    controller: _pinCode,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Pin-code",
                    ),
                    validator: (val) {
                      return val.isEmpty ? "This is Required" : null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "We will share this detail only with the Cafe when you order someting",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                isPressed
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isPressed = false;
                                  });
                                  FirebaseCallbacks()
                                      .createUser(
                                          widget.user.email,
                                          widget.user.displayName,
                                          controller.text,
                                          _adsL1.text +
                                              ', ' +
                                              _adsL2.text +
                                              ', ' +
                                              _city.text +
                                              ', ' +
                                              _pinCode.text,
                                          msgToken)
                                      .then((value) {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) => Home(
                                                  sp: widget.sp,
                                                  user: widget.user,
                                                  phone: controller.text,
                                                  msgToken: msgToken,
                                                )));
                                  });
                                }
                              },
                              shape: StadiumBorder(),
                              fillColor: Colors.orange,
                              child: Text("SAVE"),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                if (widget.fromOrderPage) {
                                  Navigator.pop(context);
                                }
                                setState(() {
                                  isPressed = false;
                                });
                                FirebaseCallbacks()
                                    .createUser(
                                        widget.user.email,
                                        widget.user.displayName,
                                        "Not Provided",
                                        "Not Provided",
                                        msgToken)
                                    .then((value) {
                                  if (widget.sp != null)
                                    widget.sp.setBool('available', true);
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) => Home(
                                                sp: widget.sp,
                                                user: widget.user,
                                                phone: "Not Provided",
                                                msgToken: msgToken,
                                              )));
                                });
                              },
                              shape: StadiumBorder(),
                              fillColor: Colors.orange,
                              child: widget.fromOrderPage
                                  ? Text("BACK")
                                  : Text("SKIP"),
                            )
                          ],
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
