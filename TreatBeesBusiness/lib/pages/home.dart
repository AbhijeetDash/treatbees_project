import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treatbees_business/pages/canceled.dart';
import 'package:treatbees_business/pages/completed.dart';
import 'package:treatbees_business/pages/delivery_services.dart';
import 'package:treatbees_business/pages/history.dart';
import 'package:treatbees_business/pages/menu.dart';
import 'package:treatbees_business/pages/qrcode.dart';
import 'package:treatbees_business/pages/rejected.dart';
import 'package:treatbees_business/utils/theme.dart';
import 'package:treatbees_business/utils/widget.dart';

class Home extends StatefulWidget {
  final SharedPreferences sp;
  final User user;
  final String code;
  bool menu;
  Home({@required this.sp, this.user, @required this.code, this.menu});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String docName;
  DateTime now;
  List<String> month;
  List<Widget> tabs = [];
  int _tabIndex = 0;

  void _modalBottomSheetMenu() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await showModalBottomSheet(
          enableDrag: false,
          isDismissible: false,
          context: context,
          builder: (builder) {
            return Container(
                height: 200.0,
                child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0))),
                    child: Column(
                      children: [
                        Text(
                          "Welcome",
                          style: MyFonts().smallHeadingBold,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'You need to create a menu for your cafe\nTell us what you offer so that\nwe can promote your cafe',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: FlatButton(
                              color: Colors.orange,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => MenuManager(
                                              isMenuAvailable: widget.menu,
                                              code: widget.code,
                                            )));
                              },
                              child: Text("Create Menu")),
                        )
                      ],
                    )));
          });
    });
  }

  @override
  void initState() {
    if (widget.sp != null) widget.sp.setBool('available', true);

    now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    docName = formattedDate.replaceAll("-", " : ");
    month = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    if (widget.menu != true) {
      _modalBottomSheetMenu();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tabs = [
      AllOrders(
          now: now,
          month: month,
          widget: widget,
          docName: docName,
          code: widget.code),
      NewOrders(
          now: now,
          month: month,
          widget: widget,
          docName: docName,
          code: widget.code),
      AcceptedOrders(
          now: now,
          month: month,
          widget: widget,
          docName: docName,
          code: widget.code),
      PreparingOrders(
          now: now,
          month: month,
          widget: widget,
          docName: docName,
          code: widget.code),
      ReadyOrders(
          now: now,
          month: month,
          widget: widget,
          docName: docName,
          code: widget.code),
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().alice,
        titleSpacing: 0.0,
        elevation: 0.0,
        title: TitleWidget(),
        actions: [
          UserAppBarTile(
            user: widget.user,
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: MyColors().alice,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    height: 200,
                    width: size.width * 0.9,
                    alignment: Alignment.center,
                    child: Container(
                      height: 200,
                      width: size.width * 0.9,
                      alignment: Alignment.centerLeft,
                      child: ListTile(
                        title: Text(
                          widget.user.displayName,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        subtitle: Text(
                          widget.user.email,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(widget.user.photoURL),
                        ),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                            Colors.grey[850].withOpacity(0.6),
                            Colors.black.withOpacity(0.8)
                          ])),
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://images.unsplash.com/photo-1484300681262-5cca666b0954?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'))),
                  ),
                  SizedBox(height: 20),
                  OptionTile(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Completed(
                              date:
                                  '${now.day} ${month[now.month - 1]} ${now.year}',
                              code: widget.code,
                              docName: docName)));
                    },
                    icon: Icons.done_all,
                    title: "Completed Orders",
                    subTitle: "View today's completed orders",
                  ),
                  OptionTile(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Rejected(
                                  date:
                                      '${now.day} ${month[now.month - 1]} ${now.year}',
                                  code: widget.code,
                                  docName: docName)));
                    },
                    icon: Icons.cancel,
                    title: "Rejected Orders",
                    subTitle: "View rejected orders",
                  ),
                  OptionTile(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Canceled(
                                  date:
                                      '${now.day} ${month[now.month - 1]} ${now.year}',
                                  code: widget.code,
                                  docName: docName)));
                    },
                    icon: Icons.remove_circle_outline,
                    title: "Cancelled Orders",
                    subTitle: "View cancelled orders",
                  ),
                  OptionTile(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => History(
                            code: widget.code,
                          )
                      ));
                    },
                    icon: Icons.history,
                    title: "Order History",
                    subTitle: "View all order history",
                  ),
                  OptionTile(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ServiceEdit(
                            code: widget.code,
                          )));
                    },
                    icon: Icons.room_service_rounded,
                    title: "Edit Services",
                    subTitle: "View and Download your qr code",
                  ),
                  OptionTile(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewQR(
                                code: widget.code,
                              )));
                    },
                    icon: Icons.qr_code,
                    title: "QR Code",
                    subTitle: "View and Download your qr code",
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("version 1.0 MVP"),
              )
            ],
          ),
        ),
      ),
      body: tabs[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        elevation: 0.0,
        onTap: (insect) {
          setState(() {
            _tabIndex = insect;
          });
        },
        items: [
          BottomNavigationBarItem(
              label: "ALL ORDERS",
              icon: Icon(Icons.book_rounded),
              backgroundColor: Colors.orange),
          BottomNavigationBarItem(
              label: "NEW",
              icon: Icon(Icons.circle_notifications),
              backgroundColor: Colors.indigo[700]),
          BottomNavigationBarItem(
              label: "ACCEPTED",
              icon: Icon(Icons.done_all_outlined),
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
            label: "PREPARING",
            icon: Icon(Icons.local_dining_outlined),
            backgroundColor: Colors.orangeAccent[700],
          ),
          BottomNavigationBarItem(
              label: "READY",
              icon: Icon(Icons.fastfood),
              backgroundColor: Colors.green),
        ],
      ),
    );
  }
}

class AllOrders extends StatefulWidget {
  const AllOrders({
    Key key,
    @required this.now,
    @required this.month,
    @required this.widget,
    @required this.docName,
    @required this.code,
  }) : super(key: key);

  final DateTime now;
  final List<String> month;
  final Home widget;
  final String docName;
  final String code;

  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height,
        color: MyColors().alice,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text:
                              '${widget.now.day} ${widget.month[widget.now.month - 1]} ${widget.now.year}',
                          style: MyFonts().smallHeadingBold),
                      TextSpan(
                          text: '\n List of todays order',
                          style: TextStyle(fontSize: 14, color: Colors.black))
                    ]),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuManager(
                                    isMenuAvailable: true,
                                    code: widget.code,
                                  )));
                    },
                    shape: StadiumBorder(),
                    fillColor: Colors.orange,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Menu"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(widget.widget.code)
                      .doc('CafeOrders')
                      .collection(widget.docName)
                      .where(
                    'orderStatus',
                    whereNotIn: ["rejected", "canceled", "collected"],
                  ).snapshots(),
                  builder: (context, stream) {

                    if (stream.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (stream.hasError) {
                      return Center(child: Text(stream.error.toString()));
                    }

                    QuerySnapshot querySnapshot = stream.data;

                    if (querySnapshot.size == 0) {
                      return Container(
                        height: size.height * 0.725,
                        child: Center(
                          child: Text(
                            "You do not\nhave any orders",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return Container(
                      height: size.height * 0.725,
                      child: ListView.builder(
                          itemCount: querySnapshot.size,
                          itemBuilder: (context, index) {

                            /// Calculating the amount
                            int paidAmount = 0;
                            querySnapshot.docs[index]
                                .data()['orderItems']
                                .forEach((item) => {
                                      paidAmount +=
                                          int.parse(item['TotalPrice'])*int.parse(item['ItemQuantity'])
                                    });


                            String orderID = querySnapshot.docs[index].id;


                            List<Widget> orderItemsWidget = [];

                            querySnapshot.docs[index].data()['orderItems'].forEach((element){
                              orderItemsWidget.add(
                                  Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          element['ItemName'] +
                                              " X" +
                                              element['ItemQuantity'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        Text(
                                            element['TotalPrice'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18))
                                      ],
                                    ),
                                  )
                              );
                            });


                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        MyColors().shadowDark,
                                        MyColors().alice,
                                      ]),
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
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Order ID"),
                                              Text(
                                                orderID.split('T')[1].split('.')[1].split('|')[0],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      ' ' +
                                                          querySnapshot.docs[index]
                                                              .data()['orderType']
                                                              .toString()
                                                              .toUpperCase() +
                                                          ' ',
                                                      style: TextStyle(
                                                          wordSpacing: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          backgroundColor: querySnapshot
                                                              .docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "ordered"
                                                              ? Colors.indigo[700]
                                                              : querySnapshot.docs[
                                                          index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "accepted"
                                                              ? Colors.red
                                                              : querySnapshot.docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "preparing"
                                                              ? Colors.orangeAccent[
                                                          700]
                                                              : Colors
                                                              .green)),
                                                  SizedBox(width: 10,),
                                                  Text(
                                                      ' ' +
                                                          querySnapshot.docs[index]
                                                              .data()['orderStatus']
                                                              .toString()
                                                              .toUpperCase() +
                                                          ' ',
                                                      style: TextStyle(
                                                          wordSpacing: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          backgroundColor: querySnapshot
                                                                          .docs[index]
                                                                          .data()[
                                                                      'orderStatus'] ==
                                                                  "ordered"
                                                              ? Colors.indigo[700]
                                                              : querySnapshot.docs[
                                                                                  index]
                                                                              .data()[
                                                                          'orderStatus'] ==
                                                                      "accepted"
                                                                  ? Colors.red
                                                                  : querySnapshot.docs[index]
                                                                                  .data()[
                                                                              'orderStatus'] ==
                                                                          "preparing"
                                                                      ? Colors.orangeAccent[
                                                                          700]
                                                                      : Colors
                                                                          .green)),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("Order Time  :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                                  SizedBox(width: 10,),
                                                  Text(orderID.split('T')[1].split('.')[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: querySnapshot.docs[index]
                                                .data()['orderItems']
                                                .length *
                                            30.0,
                                        child: Column(
                                            children: orderItemsWidget,
                                        )
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Ordered By",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            querySnapshot.docs[index]
                                                .data()['userName'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            ' Paid | RS $paidAmount ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      querySnapshot.docs[index]
                                          .data()['orderType']
                                          .toString()
                                          .toUpperCase()=="DELIVERY"?
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Delivery Address", style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox( width: size.width - 100,child: Text(querySnapshot.docs[index].data()['useraddress'].toString().replaceAll(' ,', '\n'))),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ):Container(),

                                      querySnapshot.docs[index]
                                                  .data()['orderStatus'] ==
                                              "ordered"
                                          ? AcceptRejectButtons(
                                              code: widget.code,
                                              docName: widget.docName,
                                              querySnapshot: querySnapshot,
                                              index: index,
                                            )
                                          : querySnapshot.docs[index]
                                                      .data()['orderStatus'] ==
                                                  "accepted"
                                              ? PreparingButton(
                                                  size: size,
                                                  code: widget.code,
                                                  docName: widget.docName,
                                                  querySnapshot: querySnapshot,
                                                  index: index)
                                              : querySnapshot.docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                      "preparing"
                                                  ? ReadyButton(
                                                      size: size,
                                                      code: widget.code,
                                                      docName: widget.docName,
                                                      querySnapshot:
                                                          querySnapshot,
                                                      index: index)
                                                  : CompleteButton(
                                                      size: size,
                                                    )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}

class NewOrders extends StatefulWidget {
  const NewOrders({
    Key key,
    @required this.now,
    @required this.month,
    @required this.widget,
    @required this.docName,
    @required this.code,
  }) : super(key: key);

  final DateTime now;
  final List<String> month;
  final Home widget;
  final String docName;
  final String code;

  @override
  _NewOrdersState createState() => _NewOrdersState();
}

class _NewOrdersState extends State<NewOrders> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height,
        color: MyColors().alice,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text:
                          '${widget.now.day} ${widget.month[widget.now.month - 1]} ${widget.now.year}',
                      style: MyFonts().smallHeadingBold),
                  TextSpan(
                      text: '\n List of todays order',
                      style: TextStyle(fontSize: 14, color: Colors.black))
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(widget.widget.code)
                      .doc('CafeOrders')
                      .collection(widget.docName)
                      .where('orderStatus', isEqualTo: "ordered")
                      .snapshots(),
                  builder: (context, stream) {
                    if (stream.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (stream.hasError) {
                      return Center(child: Text(stream.error.toString()));
                    }

                    QuerySnapshot querySnapshot = stream.data;

                    if (querySnapshot.size == 0) {
                      return Container(
                        height: size.height * 0.725,
                        child: Center(
                          child: Text(
                            "You don't have\nany new orders",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return Container(
                      height: size.height * 0.725,
                      child: ListView.builder(
                          itemCount: querySnapshot.size,
                          itemBuilder: (context, index) {
                            int paidAmount = 0;
                            querySnapshot.docs[index]
                                .data()['orderItems']
                                .forEach((item) => {
                                      paidAmount +=
                                          int.parse(item['TotalPrice'])*int.parse(item['ItemQuantity'])
                                    });

                            String orderID = querySnapshot.docs[index].id;


                            List<Widget> orderItemsWidget = [];

                            querySnapshot.docs[index].data()['orderItems'].forEach((element){
                              orderItemsWidget.add(
                                  Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          element['ItemName'] +
                                              " X" +
                                              element['ItemQuantity'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        Text(
                                            element['TotalPrice'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18))
                                      ],
                                    ),
                                  )
                              );
                            });

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        MyColors().shadowDark,
                                        MyColors().alice,
                                      ]),
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
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Order ID"),
                                              Text(
                                                orderID.split('T')[1].split('.')[1].split('|')[0],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      ' ' +
                                                          querySnapshot.docs[index]
                                                              .data()['orderType']
                                                              .toString()
                                                              .toUpperCase() +
                                                          ' ',
                                                      style: TextStyle(
                                                          wordSpacing: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          backgroundColor: querySnapshot
                                                              .docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "ordered"
                                                              ? Colors.indigo[700]
                                                              : querySnapshot.docs[
                                                          index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "accepted"
                                                              ? Colors.red
                                                              : querySnapshot.docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "preparing"
                                                              ? Colors.orangeAccent[
                                                          700]
                                                              : Colors
                                                              .green)),
                                                  SizedBox(width: 10,),
                                                  Text(
                                                      ' ' +
                                                          querySnapshot.docs[index]
                                                              .data()['orderStatus']
                                                              .toString()
                                                              .toUpperCase() +
                                                          ' ',
                                                      style: TextStyle(
                                                          wordSpacing: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          backgroundColor: querySnapshot
                                                              .docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "ordered"
                                                              ? Colors.indigo[700]
                                                              : querySnapshot.docs[
                                                          index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "accepted"
                                                              ? Colors.red
                                                              : querySnapshot.docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "preparing"
                                                              ? Colors.orangeAccent[
                                                          700]
                                                              : Colors
                                                              .green)),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("Order Time  :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                                  SizedBox(width: 10,),
                                                  Text(orderID.split('T')[1].split('.')[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                          height: querySnapshot.docs[index]
                                              .data()['orderItems']
                                              .length *
                                              30.0,
                                          child: Column(
                                            children: orderItemsWidget,
                                          )
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Ordered By",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            querySnapshot.docs[index]
                                                .data()['userName'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            ' Paid | RS $paidAmount ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      querySnapshot.docs[index]
                                          .data()['orderType']
                                          .toString()
                                          .toUpperCase()=="DELIVERY"?
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Delivery Address", style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox( width: size.width - 100,child: Text(querySnapshot.docs[index].data()['useraddress'].toString().replaceAll(' ,', '\n'))),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ):Container(),
                                      // Add Accept Reject Buttons
                                      AcceptRejectButtons(
                                        code: widget.code,
                                        docName: widget.docName,
                                        querySnapshot: querySnapshot,
                                        index: index,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}

class AcceptedOrders extends StatefulWidget {
  const AcceptedOrders({
    Key key,
    @required this.now,
    @required this.month,
    @required this.widget,
    @required this.docName,
    @required this.code,
  }) : super(key: key);

  final DateTime now;
  final List<String> month;
  final Home widget;
  final String docName;
  final String code;

  @override
  _AcceptedOrdersState createState() => _AcceptedOrdersState();
}

class _AcceptedOrdersState extends State<AcceptedOrders> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height,
        color: MyColors().alice,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text:
                          '${widget.now.day} ${widget.month[widget.now.month - 1]} ${widget.now.year}',
                      style: MyFonts().smallHeadingBold),
                  TextSpan(
                      text: '\n List of todays order',
                      style: TextStyle(fontSize: 14, color: Colors.black))
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(widget.widget.code)
                      .doc('CafeOrders')
                      .collection(widget.docName)
                      .where('orderStatus', isEqualTo: "accepted")
                      .snapshots(),
                  builder: (context, stream) {
                    if (stream.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (stream.hasError) {
                      return Center(child: Text(stream.error.toString()));
                    }

                    QuerySnapshot querySnapshot = stream.data;

                    if (querySnapshot.size == 0) {
                      return Container(
                        height: size.height * 0.725,
                        child: Center(
                          child: Text(
                            "You have not\naccepted any orders",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return Container(
                      height: size.height * 0.725,
                      child: ListView.builder(
                          itemCount: querySnapshot.size,
                          itemBuilder: (context, index) {
                            int paidAmount = 0;
                            querySnapshot.docs[index]
                                .data()['orderItems']
                                .forEach((item) => {
                                      paidAmount +=
                                          int.parse(item['TotalPrice'])*int.parse(item['ItemQuantity'])
                                    });

                            String orderID = querySnapshot.docs[index].id;


                            List<Widget> orderItemsWidget = [];

                            querySnapshot.docs[index].data()['orderItems'].forEach((element){
                              orderItemsWidget.add(
                                  Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          element['ItemName'] +
                                              " X" +
                                              element['ItemQuantity'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        Text(
                                            element['TotalPrice'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18))
                                      ],
                                    ),
                                  )
                              );
                            });

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        MyColors().shadowDark,
                                        MyColors().alice,
                                      ]),
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
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Order ID"),
                                              Text(
                                                orderID.split('T')[1].split('.')[1].split('|')[0],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      ' ' +
                                                          querySnapshot.docs[index]
                                                              .data()['orderType']
                                                              .toString()
                                                              .toUpperCase() +
                                                          ' ',
                                                      style: TextStyle(
                                                          wordSpacing: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          backgroundColor: querySnapshot
                                                              .docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "ordered"
                                                              ? Colors.indigo[700]
                                                              : querySnapshot.docs[
                                                          index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "accepted"
                                                              ? Colors.red
                                                              : querySnapshot.docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "preparing"
                                                              ? Colors.orangeAccent[
                                                          700]
                                                              : Colors
                                                              .green)),
                                                  SizedBox(width: 10,),
                                                  Text(
                                                      ' ' +
                                                          querySnapshot.docs[index]
                                                              .data()['orderStatus']
                                                              .toString()
                                                              .toUpperCase() +
                                                          ' ',
                                                      style: TextStyle(
                                                          wordSpacing: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          backgroundColor: querySnapshot
                                                              .docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "ordered"
                                                              ? Colors.indigo[700]
                                                              : querySnapshot.docs[
                                                          index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "accepted"
                                                              ? Colors.red
                                                              : querySnapshot.docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "preparing"
                                                              ? Colors.orangeAccent[
                                                          700]
                                                              : Colors
                                                              .green)),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("Order Time  :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                                  SizedBox(width: 10,),
                                                  Text(orderID.split('T')[1].split('.')[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                          height: querySnapshot.docs[index]
                                              .data()['orderItems']
                                              .length *
                                              30.0,
                                          child: Column(
                                            children: orderItemsWidget,
                                          )
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Ordered By",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            querySnapshot.docs[index]
                                                .data()['userName'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            ' Paid | RS $paidAmount ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      querySnapshot.docs[index]
                                          .data()['orderType']
                                          .toString()
                                          .toUpperCase()=="DELIVERY"?
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Delivery Address", style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox( width: size.width - 100,child: Text(querySnapshot.docs[index].data()['useraddress'].toString().replaceAll(' ,', '\n'))),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ):Container(),
                                      PreparingButton(
                                          size: size,
                                          code: widget.code,
                                          docName: widget.docName,
                                          querySnapshot: querySnapshot,
                                          index: index)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}

class PreparingOrders extends StatefulWidget {
  const PreparingOrders({
    Key key,
    @required this.now,
    @required this.month,
    @required this.widget,
    @required this.docName,
    @required this.code,
  }) : super(key: key);

  final DateTime now;
  final List<String> month;
  final Home widget;
  final String docName;
  final String code;

  @override
  _PreparingOrdersState createState() => _PreparingOrdersState();
}

class _PreparingOrdersState extends State<PreparingOrders> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height,
        color: MyColors().alice,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text:
                          '${widget.now.day} ${widget.month[widget.now.month - 1]} ${widget.now.year}',
                      style: MyFonts().smallHeadingBold),
                  TextSpan(
                      text: '\n List of todays order',
                      style: TextStyle(fontSize: 14, color: Colors.black))
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(widget.widget.code)
                      .doc('CafeOrders')
                      .collection(widget.docName)
                      .where('orderStatus', isEqualTo: "preparing")
                      .snapshots(),
                  builder: (context, stream) {
                    if (stream.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (stream.hasError) {
                      return Center(child: Text(stream.error.toString()));
                    }

                    QuerySnapshot querySnapshot = stream.data;

                    if (querySnapshot.size == 0) {
                      return Container(
                        height: size.height * 0.725,
                        child: Center(
                          child: Text(
                            "You are not\npreparing any orders",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return Container(
                      height: size.height * 0.725,
                      child: ListView.builder(
                          itemCount: querySnapshot.size,
                          itemBuilder: (context, index) {
                            int paidAmount = 0;
                            querySnapshot.docs[index]
                                .data()['orderItems']
                                .forEach((item) => {
                                      paidAmount +=
                                          int.parse(item['TotalPrice'])*int.parse(item['ItemQuantity'])
                                    });

                            String orderID = querySnapshot.docs[index].id;


                            List<Widget> orderItemsWidget = [];

                            querySnapshot.docs[index].data()['orderItems'].forEach((element){
                              orderItemsWidget.add(
                                  Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          element['ItemName'] +
                                              " X" +
                                              element['ItemQuantity'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        Text(
                                            element['TotalPrice'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18))
                                      ],
                                    ),
                                  )
                              );
                            });

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        MyColors().shadowDark,
                                        MyColors().alice,
                                      ]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: MyColors().shadowDark,
                                      offset: Offset(4.0, 4.0),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    ),
                                    BoxShadow(
                                      color: MyColors().shadowLight,
                                      offset: Offset(-4.0, -4.0),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Order ID"),
                                              Text(
                                                orderID.split('T')[1].split('.')[1].split('|')[0],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      ' ' +
                                                          querySnapshot.docs[index]
                                                              .data()['orderType']
                                                              .toString()
                                                              .toUpperCase() +
                                                          ' ',
                                                      style: TextStyle(
                                                          wordSpacing: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          backgroundColor: querySnapshot
                                                              .docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "ordered"
                                                              ? Colors.indigo[700]
                                                              : querySnapshot.docs[
                                                          index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "accepted"
                                                              ? Colors.red
                                                              : querySnapshot.docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "preparing"
                                                              ? Colors.orangeAccent[
                                                          700]
                                                              : Colors
                                                              .green)),
                                                  SizedBox(width: 10,),
                                                  Text(
                                                      ' ' +
                                                          querySnapshot.docs[index]
                                                              .data()['orderStatus']
                                                              .toString()
                                                              .toUpperCase() +
                                                          ' ',
                                                      style: TextStyle(
                                                          wordSpacing: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          backgroundColor: querySnapshot
                                                              .docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "ordered"
                                                              ? Colors.indigo[700]
                                                              : querySnapshot.docs[
                                                          index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "accepted"
                                                              ? Colors.red
                                                              : querySnapshot.docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "preparing"
                                                              ? Colors.orangeAccent[
                                                          700]
                                                              : Colors
                                                              .green)),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("Order Time  :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                                  SizedBox(width: 10,),
                                                  Text(orderID.split('T')[1].split('.')[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                          height: querySnapshot.docs[index]
                                              .data()['orderItems']
                                              .length *
                                              30.0,
                                          child: Column(
                                            children: orderItemsWidget,
                                          )
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Ordered By",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            querySnapshot.docs[index]
                                                .data()['userName'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            ' Paid | RS $paidAmount ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      querySnapshot.docs[index]
                                          .data()['orderType']
                                          .toString()
                                          .toUpperCase()=="DELIVERY"?
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Delivery Address", style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox( width: size.width - 100,child: Text(querySnapshot.docs[index].data()['useraddress'].toString().replaceAll(' ,', '\n'))),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ):Container(),
                                      ReadyButton(
                                          size: size,
                                          code: widget.code,
                                          docName: widget.docName,
                                          querySnapshot: querySnapshot,
                                          index: index)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}

class ReadyOrders extends StatefulWidget {
  const ReadyOrders({
    Key key,
    @required this.now,
    @required this.month,
    @required this.widget,
    @required this.docName,
    @required this.code,
  }) : super(key: key);

  final DateTime now;
  final List<String> month;
  final Home widget;
  final String docName;
  final String code;

  @override
  _ReadyOrdersState createState() => _ReadyOrdersState();
}

class _ReadyOrdersState extends State<ReadyOrders> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height,
        color: MyColors().alice,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text:
                          '${widget.now.day} ${widget.month[widget.now.month - 1]} ${widget.now.year}',
                      style: MyFonts().smallHeadingBold),
                  TextSpan(
                      text: '\n List of todays order',
                      style: TextStyle(fontSize: 14, color: Colors.black))
                ]),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(widget.widget.code)
                      .doc('CafeOrders')
                      .collection(widget.docName)
                      .where('orderStatus', isEqualTo: "ready")
                      .snapshots(),
                  builder: (context, stream) {
                    if (stream.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (stream.hasError) {
                      return Center(child: Text(stream.error.toString()));
                    }

                    QuerySnapshot querySnapshot = stream.data;

                    if (querySnapshot.size == 0) {
                      return Container(
                        height: size.height * 0.725,
                        child: Center(
                          child: Text(
                            "You don't have\nany orders ready yet",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return Container(
                      height: size.height * 0.725,
                      child: ListView.builder(
                          itemCount: querySnapshot.size,
                          itemBuilder: (context, index) {
                            int paidAmount = 0;
                            querySnapshot.docs[index]
                                .data()['orderItems']
                                .forEach((item) => {
                                      paidAmount +=
                                          int.parse(item['TotalPrice'])*int.parse(item['ItemQuantity'])
                                    });

                            String orderID = querySnapshot.docs[index].id;


                            List<Widget> orderItemsWidget = [];

                            querySnapshot.docs[index].data()['orderItems'].forEach((element){
                              orderItemsWidget.add(
                                  Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          element['ItemName'] +
                                              " X" +
                                              element['ItemQuantity'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        Text(
                                            element['TotalPrice'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18))
                                      ],
                                    ),
                                  )
                              );
                            });

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        MyColors().shadowDark,
                                        MyColors().alice,
                                      ]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: MyColors().shadowDark,
                                      offset: Offset(4.0, 4.0),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    ),
                                    BoxShadow(
                                      color: MyColors().shadowLight,
                                      offset: Offset(-4.0, -4.0),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Order ID"),
                                              Text(
                                                orderID.split('T')[1].split('.')[1].split('|')[0],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      ' ' +
                                                          querySnapshot.docs[index]
                                                              .data()['orderType']
                                                              .toString()
                                                              .toUpperCase() +
                                                          ' ',
                                                      style: TextStyle(
                                                          wordSpacing: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          backgroundColor: querySnapshot
                                                              .docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "ordered"
                                                              ? Colors.indigo[700]
                                                              : querySnapshot.docs[
                                                          index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "accepted"
                                                              ? Colors.red
                                                              : querySnapshot.docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "preparing"
                                                              ? Colors.orangeAccent[
                                                          700]
                                                              : Colors
                                                              .green)),
                                                  SizedBox(width: 10,),
                                                  Text(
                                                      ' ' +
                                                          querySnapshot.docs[index]
                                                              .data()['orderStatus']
                                                              .toString()
                                                              .toUpperCase() +
                                                          ' ',
                                                      style: TextStyle(
                                                          wordSpacing: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          backgroundColor: querySnapshot
                                                              .docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "ordered"
                                                              ? Colors.indigo[700]
                                                              : querySnapshot.docs[
                                                          index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "accepted"
                                                              ? Colors.red
                                                              : querySnapshot.docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                              "preparing"
                                                              ? Colors.orangeAccent[
                                                          700]
                                                              : Colors
                                                              .green)),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("Order Time  :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                                  SizedBox(width: 10,),
                                                  Text(orderID.split('T')[1].split('.')[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                          height: querySnapshot.docs[index]
                                              .data()['orderItems']
                                              .length *
                                              30.0,
                                          child: Column(
                                            children: orderItemsWidget,
                                          )
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Ordered By",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            querySnapshot.docs[index]
                                                .data()['userName'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            ' Paid | RS $paidAmount ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      querySnapshot.docs[index]
                                          .data()['orderType']
                                          .toString()
                                          .toUpperCase()=="DELIVERY"?
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Delivery Address", style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox( width: size.width - 100,child: Text(querySnapshot.docs[index].data()['useraddress'].toString().replaceAll(' ,', '\n'))),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ):Container(),
                                      CompleteButton(size: size)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
