import 'package:flutter/material.dart';
import 'package:treatbees/layout/addCafe.dart';
import 'package:treatbees/layout/mpait.dart';
import 'package:treatbees/layout/theme.dart';
import 'package:treatbees/pages/aboutus.dart';
import 'package:treatbees/pages/cancellation.dart';
import 'package:treatbees/pages/contact.dart';
import 'package:treatbees/pages/privacy.dart';
import 'package:treatbees/pages/term.dart';

class WebHome extends StatefulWidget {
  @override
  _WebHomeState createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height + 200,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80'))),
        child: SingleChildScrollView(
          controller: _controller,
          child: Container(
            width: width,
            height: height + 220,
            color: Colors.black.withOpacity(0.7),
            child: Column(
              children: [
                Container(
                  width: width,
                  height: height - 20,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -300,
                        right: -300,
                        child: CustomPaint(
                          size: Size(900, 900),
                          foregroundPainter: ShapePainter(
                              shape: "circle",
                              sx: 900,
                              sy: 900,
                              color: Colors.red),
                          child: Container(
                            width: 900,
                            height: 900,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          height: height * 0.1,
                          width: width,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.fastfood,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Treat',
                                        style: MyFonts().smallHeadingBold),
                                    TextSpan(
                                        text: 'Bees',
                                        style: MyFonts().smallHeadingLight),
                                  ]),
                                ),
                                BottomNavCustom(width: width, height: height)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.1,
                        child: Container(
                            width: width,
                            height: height * 0.9,
                            child: Container(
                              width: width,
                              height: height * 0.9,
                              child: Row(
                                children: [
                                  Container(
                                    width: width * 0.5,
                                    height: height * 0.9,
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50.0, right: 50.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Welcome",
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: width * 0.3,
                                            child: Text(
                                              "We are glad to see you here. Make sure to download our application from google play store and happy ordering.",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 200,
                                            height: 80,
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                                color: Colors.yellow[900],
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        './assets/googlePlay.png'))),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.5,
                                    height: height,
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 0.1,
                                          right: width * 0.1,
                                          bottom: 50),
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    './assets/iphone.png'))),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 240,
                  width: width,
                  color: Colors.black,
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.3,
                        height: 240,
                        padding: EdgeInsets.only(top: 30, left: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Treat',
                                    style: MyFonts().smallHeadingBold),
                                TextSpan(
                                    text: 'Bees',
                                    style: MyFonts().smallHeadingLight),
                              ]),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              child: Text(
                                'About us',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AboutUS()));
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Contact us',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ContactUS()));
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PrivacyPolicy()));
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Terms & Conditions',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TermsConditions()));
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Cancellation/Refund Policy',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CancellationPolicy()));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: Colors.orange,
        child: IconButton(
            icon: Icon(
              Icons.arrow_downward,
              color: Colors.black,
            ),
            onPressed: () {
              _controller.animateTo(220,
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            }),
      ),
    );
  }
}

class BottomNavCustom extends StatelessWidget {
  const BottomNavCustom({
    Key key,
    @required this.width,
    this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.1,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyButton(
            lable: "Home",
            onPressed: () {
              //Bring Home to top
            },
          ),
          SizedBox(
            width: width * 0.001,
          ),
          MyButton(
            lable: "About us",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutUS()));
            },
          ),
          SizedBox(
            width: width * 0.001,
          ),
          // MyButton(
          //   lable: "Campus",
          //   onPressed: () {
          //     //Bring Campus to top
          //   },
          // ),
          // SizedBox(
          //   width: width * 0.001,
          // ),
          MyButton(
            lable: "Restaurant",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddCafe()));
            },
          ),
          SizedBox(
            width: width * 0.001,
          ),
          MyButton(
            lable: "Help",
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ContactUS()));
              //Bring Help to top
            },
          )
        ],
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  final String lable;
  final GestureTapCallback onPressed;

  const MyButton({Key key, @required this.lable, @required this.onPressed})
      : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        splashColor: Colors.white.withOpacity(0.6),
        shape: StadiumBorder(),
        child: Text(
          widget.lable,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: widget.onPressed);
  }
}
