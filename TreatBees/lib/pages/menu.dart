import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/pages/orderDetails.dart';
import 'package:TreatBees/utils/functions.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Selection {
  List<Map<String, String>> selected = [];
}

class Menu extends StatefulWidget {
  final String cafeName;
  final String cafeCode;
  final User user;
  final String userPhone;
  //Message Token of Cafe
  final String msgToken;
  Menu(
      {@required this.cafeName,
      this.user,
      @required this.userPhone,
      @required this.cafeCode,
      @required this.msgToken});

  Selection selection = new Selection();

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool show = false;

  void doneDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Alert",
                    style: MyFonts().smallHeadingBold,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Please select atleast\none item to continue",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.orange,
                    height: 30,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Okay"),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors().alice,
          elevation: 0.0,
          titleSpacing: 0.0,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (a, b, c) {
                  return Home(
                    sp: null,
                    user: widget.user,
                    phone: widget.userPhone,
                  );
                },
                transitionDuration: Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  animation =
                      CurvedAnimation(curve: Curves.ease, parent: animation);
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ));
            },
          ),
          title: TitleWidget(),
          actions: [
            UserAppBarTile(
              user: widget.user,
            )
          ],
        ),
        body: Container(
          color: MyColors().alice,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                ),
                child: Text(
                  widget.cafeName,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: size.height * 0.8,
                child: FutureBuilder(
                  future: FirebaseCallbacks().getMenu(widget.cafeCode),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<String> mainMenu = [];
                    List<Map<dynamic, dynamic>> menuItems = [];
                    snap.data[0]['Categories']['categories'].forEach((cat) {
                      mainMenu.add(cat);
                    });
                    snap.data[1]['Items']['items'].forEach((item) {
                      menuItems.add(item);
                    });
                    return ListView.builder(
                      itemCount: mainMenu.length,
                      itemBuilder: (context, index) {
                        List<Widget> cateItems = [];
                        menuItems.forEach((element) {
                          if (element['Category'] == mainMenu[index]) {
                            cateItems.add(Menutile(
                                icon: Icons.emoji_food_beverage,
                                title: element['DishName'],
                                price: element['Price'],
                                avai: element['Availability'],
                                selection: widget.selection));
                          }
                        });
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MenuSectionHeading(title: mainMenu[index]),
                              Column(
                                children: cateItems,
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: RawMaterialButton(
          onPressed: () {
            if (widget.selection.selected.length > 0) {
              Navigator.of(context)
                  .push(PageRouteBuilder(
                    pageBuilder: (a, b, c) {
                      return Ord(
                        user: widget.user,
                        cafeCode: widget.cafeCode,
                        userPhone: widget.userPhone,
                        selection: widget.selection,
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
                  .then((value) => {
                        FirebaseAnalytics().logEvent(
                            name: "AddedToCart",
                            parameters: {"Status": "Added Items To cart"})
                      });
            } else {
              doneDialog(context);
            }
          },
          shape: StadiumBorder(),
          fillColor: Colors.orange,
          child: Text("Order now"),
        ));
  }
}
