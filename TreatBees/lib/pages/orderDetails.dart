import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/pages/menu.dart';
import 'package:TreatBees/pages/userDetails.dart';
import 'package:TreatBees/utils/payment.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:TreatBees/utils/functions.dart';

class Ord extends StatefulWidget {
  final User user;
  final String cafeCode;
  final String userPhone;
  final Selection selection;
  const Ord(
      {Key key,
      this.user,
      this.cafeCode,
      @required this.userPhone,
      @required this.selection})
      : super(key: key);
  @override
  _OrdState createState() => _OrdState();
}

class _OrdState extends State<Ord> {
  //Widget delivery;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _hour, _minute, _time, _session;
  int _nowHrs, _nowMin;
  TextEditingController _timeController = TextEditingController();
  String ndropdownValue = 'Select Order Type';
  int paymentType = 1;
  String paymentButtonText = 'Continue to Pay';

  Color delCol;
  int total = 0;
  bool isButtonEnabled;
  String docName;
  String orderType;
  String userAddress = 'a';

  List<Map<String, String>> orderItems = [];
  List<String> itemsNames = [];
  List<int> itemQuantity = [];
  List<int> price = [];
  List<int> indvPrice = [];
  List<String> collectOptions = ['Select Order Type', 'Pre-order', 'Takeout', 'Delivery',];
  //
  // void validateTime() {}
  //
  // void selectTime(BuildContext context) async {
  //   final TimeOfDay picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay(
  //         hour: DateTime.now().minute > 30
  //             ? DateTime.now().hour + 1
  //             : DateTime.now().hour,
  //         minute: DateTime.now().minute > 30
  //             ? DateTime.now().minute + 30 - 60
  //             : DateTime.now().minute + 30),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       selectedTime = picked;
  //     });
  //     double newSelectedTime = selectedTime.hour + selectedTime.minute / 60.0;
  //     double nowTime = TimeOfDay.now().hour + TimeOfDay.now().minute / 60.0;
  //     if (newSelectedTime > nowTime) {
  //       setState(() {
  //         isButtonEnabled = true;
  //         _minute = selectedTime.minute.toString();
  //         _session = selectedTime.period.toString().split('.')[1];
  //         _hour = _session == 'pm'
  //             ? (selectedTime.hour - 12).toString()
  //             : selectedTime.hour.toString();
  //         if (_hour == '0') {
  //           _hour = '12';
  //         }
  //         if (_minute == '0') {
  //           _minute = '00';
  //         }
  //         _time = _hour + ' : ' + _minute + ' ' + _session;
  //         _timeController.text = _time;
  //       });
  //     } else {
  //       invalidTimeDialog(context);
  //     }
  //   }
  // }

  void generateFinalData() {
    setState(() {
      for (var i = 0; i < itemsNames.length; i++) {
        orderItems.add({
          "ItemName": itemsNames[i].toString(),
          "ItemQuantity": itemQuantity[i].toString(),
          "TotalPrice": price[i].toString()
        });
      }
    });
  }

  void separate() {
    widget.selection.selected.forEach((element) {
      setState(() {
        itemsNames.add(element['DishName']);
        itemQuantity.add(int.parse(element['Quantity']));
        price.add(int.parse(element['Price']));
        indvPrice.add(
            (int.parse(element['Price']) * int.parse(element['Quantity'])));
      });
    });
  }

  void calTotalPrice() {
    setState(() {
      total = 0;
      indvPrice.forEach((element) {
        total += element;
      });
    });
  }

  @override
  void initState() {
    FirebaseCallbacks().getCurrentUser(widget.user.email).then((value) {
      setState(() {
        userAddress = value['address'];
      });
    });
    separate();
    calTotalPrice();
    isButtonEnabled = false;
    delCol = MyColors().alice;
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    docName = formattedDate.replaceAll("-", " : ");
    super.initState();
  }

  void gotohome() {
    Navigator.of(context).pop(PageRouteBuilder(
      pageBuilder: (a, b, c) {
        return Home(
          sp: null,
          user: widget.user,
          phone: widget.userPhone,
        );
      },
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        animation = CurvedAnimation(curve: Curves.ease, parent: animation);
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ));
  }

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
                    "Collected",
                    style: MyFonts().smallHeadingBold,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Enjoy your meal",
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
                        gotohome();
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

  void invalidTimeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                  "Invalid Time",
                  style: MyFonts().smallHeadingBold,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Please enter a valid time\nwe can't do time travel.",
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().alice,
        elevation: 0.0,
        titleSpacing: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            setState(() {
              widget.selection.selected = [];
              itemsNames = [];
              itemQuantity = [];
              price = [];
              indvPrice = [];
            });
            gotohome();
          },
        ),
        title: Hero(tag: "Title", child: TitleWidget()),
        actions: [
          UserAppBarTile(
            user: widget.user,
          )
        ],
      ),
      body: Container(
        color: MyColors().alice,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemsNames.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 18.0, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.5,
                                child: Wrap(
                                  runSpacing: 5,
                                  children: [
                                    Text('${itemsNames[i]} x '),
                                    Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          color: Colors.orange,
                                          child: RawMaterialButton(
                                              onPressed: () {
                                                setState(() {
                                                  itemQuantity[i]++;
                                                  indvPrice[i] += price[i];
                                                });
                                                calTotalPrice();
                                              },
                                              child: Icon(Icons.add)),
                                        ),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          color: Colors.black,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${itemQuantity[i].toString()}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          color: Colors.orange,
                                          child: RawMaterialButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (itemQuantity[i] > 1) {
                                                    itemQuantity[i]--;
                                                    indvPrice[i] -= price[i];
                                                    calTotalPrice();
                                                  }
                                                });
                                              },
                                              child: Icon(Icons.remove)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text('RS ${indvPrice[i]}')
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30.0, top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('RS $total',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future:  FirebaseCallbacks().getOneCafe(widget.cafeCode),
              builder: (context, snapshot) {

                if(!snapshot.hasData){
                  return Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  );
                }

                if(snapshot.data['isDelivery'] == false){
                  collectOptions.remove('Delivery');
                }
                if(snapshot.data['isTakeout'] == false){
                  collectOptions.remove('Takeout');
                }
                if(snapshot.data['isPreOrder'] == false){
                  collectOptions.remove('Pre-order');
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Select payment options', style: Theme.of(context).textTheme.subtitle2,),
                          SizedBox(height: 10,),
                          snapshot.data['isDelivery']? ListTile(
                            title: const Text('Cash on Delivery - COD'),
                            leading: Radio(
                              value: 0,
                              groupValue: paymentType,
                              onChanged: (nvalue) {
                                setState(() {
                                  paymentButtonText = "Place Order";
                                  isButtonEnabled = true;
                                  paymentType = nvalue;
                                  ndropdownValue = 'Delivery';
                                });
                              },
                            ),
                          ):Text("Sorry, this cafe is providing COD at the moment."),
                          ListTile(
                            title: const Text('Online Payment'),
                            leading: Radio(
                              value: 1,
                              groupValue: paymentType,
                              onChanged: (nvalue) {
                                setState(() {
                                  paymentButtonText = "Continue to Pay";
                                  paymentType = nvalue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Container(
                        child: DropdownButton<String>(
                          value: ndropdownValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.orange,
                          ),
                          onChanged: (String newValue) {
                            if (newValue == 'Select Order Type') {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        width: 200,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 10),
                                            Text("Not a valid type"),
                                            SizedBox(height: 10),
                                            RawMaterialButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              disabledElevation: 0.0,
                                              splashColor: Colors.orange[50],
                                              shape: StadiumBorder(),
                                              elevation: 0.0,
                                              fillColor: Colors.orangeAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(14.0),
                                                child: Text("Okay",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              if (newValue == 'Delivery' &&
                                  userAddress == 'Not Provided') {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UserDetails(
                                        fromOrderPage: true, user: widget.user)));
                              } else {
                                if((paymentType == 0 && newValue != 'Delivery')){
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Container(
                                            width: 200,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(height: 10),
                                                Text("Not a valid type"),
                                                SizedBox(height: 10),
                                                RawMaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  disabledElevation: 0.0,
                                                  splashColor: Colors.orange[50],
                                                  shape: StadiumBorder(),
                                                  elevation: 0.0,
                                                  fillColor: Colors.orangeAccent,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(14.0),
                                                    child: Text("Okay",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  setState(() {
                                    ndropdownValue = newValue;
                                    isButtonEnabled = true;
                                  });
                                }
                              }
                            }
                          },
                          items: collectOptions.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                  width: MediaQuery.of(context).size.width - 100,
                                  child: Text(value)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }
            ),
            ndropdownValue == 'Delivery'
                ? Container(
                    child: userAddress == 'Not Provided'
                        ? Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 18.0,
                                right: 18.0,
                              ),
                              child: RawMaterialButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UserDetails(
                                          fromOrderPage: true,
                                          user: widget.user)));
                                },
                                disabledElevation: 0.0,
                                splashColor: Colors.orange[50],
                                elevation: 0.0,
                                fillColor: Colors.orangeAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text("Add contact details",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 25.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("We have the following address",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(userAddress,
                                    style: TextStyle(fontSize: 17)),
                              ],
                            ),
                          ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 30),
              child: Container(
                width: width - 20,
                color: isButtonEnabled ? Colors.orangeAccent : Colors.grey[200],
                child: RawMaterialButton(
                  onPressed: isButtonEnabled
                      ? paymentType == 0?(){
                    generateFinalData();
                    FirebaseCallbacks().placeOrder(docName, widget.user.displayName, widget.user.email, widget.userPhone,
                        widget.cafeCode, "ASAP", orderItems, DateTime.now().toIso8601String(), ndropdownValue);
                  }:() {
                          generateFinalData();
                          FirebaseAnalytics()
                              .logEvent(name: "PaymentRedirect")
                              .then((value) => {
                                    Payments(
                                            docName,
                                            widget.user.displayName,
                                            widget.user.email,
                                            widget.cafeCode,
                                            _time,
                                            widget.userPhone,
                                            orderItems,
                                            context,
                                            ndropdownValue)
                                        .createOrder(
                                          total * 100,
                                          widget.user.displayName,
                                          widget.user.email,
                                          widget.userPhone,
                                        )
                                        .then((value) => {})
                                  });
                        }
                      : null,
                  disabledElevation: 0.0,
                  splashColor: Colors.orange[50],
                  shape: StadiumBorder(),
                  elevation: 0.0,
                  fillColor:
                      isButtonEnabled ? Colors.orangeAccent : Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(paymentButtonText,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
