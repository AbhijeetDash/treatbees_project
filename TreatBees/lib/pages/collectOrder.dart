import 'package:TreatBees/pages/finalCollect.dart';
import 'package:TreatBees/utils/functions.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CollectOrder extends StatefulWidget {
  final User user;
  const CollectOrder({Key key, @required this.user}) : super(key: key);

  @override
  _CollectOrderState createState() => _CollectOrderState();
}

class _CollectOrderState extends State<CollectOrder> {
  DateTime now;
  String docName;

  @override
  void initState() {
    now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    docName = formattedDate.replaceAll("-", " : ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors().alice,
          elevation: 0.0,
          titleSpacing: 0.0,
          title: TitleWidget(),
          actions: [
            UserAppBarTile(
              user: widget.user,
            )
          ],
        ),
        body: Container(
          color: MyColors().alice,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(widget.user.email)
                .collection(docName)
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
                      "You do not\nhave any orders to collect",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return Container(
                height: size.height * 0.9,
                child: ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (context, index) {
                    int paidAmount = 0;
                    querySnapshot.docs[index].data()['orderItems'].forEach(
                        (item) =>
                            {paidAmount += int.parse(item['TotalPrice'])});
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Pickup At"),
                                      Text(
                                        querySnapshot.docs[index].id
                                            .split("|")[0],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
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
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: querySnapshot
                                                      .docs[index]
                                                      .data()['orderStatus'] ==
                                                  "ordered"
                                              ? Colors.indigo[700]
                                              : querySnapshot.docs[index]
                                                              .data()[
                                                          'orderStatus'] ==
                                                      "accepted"
                                                  ? Colors.red
                                                  : querySnapshot.docs[index]
                                                                  .data()[
                                                              'orderStatus'] ==
                                                          "preparing"
                                                      ? Colors.orangeAccent[700]
                                                      : querySnapshot.docs[
                                                                          index]
                                                                      .data()[
                                                                  'orderStatus'] ==
                                                              "rejected"
                                                          ? Colors.black
                                                          : Colors.green)),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: querySnapshot.docs[index]
                                        .data()['orderItems']
                                        .length *
                                    30.0,
                                child: ListView.builder(
                                    itemCount: querySnapshot.docs[index]
                                        .data()['orderItems']
                                        .length,
                                    itemBuilder: (context, i) {
                                      return Container(
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              querySnapshot.docs[index]
                                                          .data()['orderItems']
                                                      [i]['ItemName'] +
                                                  " X" +
                                                  querySnapshot.docs[index]
                                                      .data()['orderItems'][i]
                                                          ['ItemQuantity']
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                                querySnapshot.docs[index]
                                                    .data()['orderItems'][i]
                                                        ['TotalPrice']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18))
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Ordered At",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
                                        .data()['cafeCode'],
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    ' Paid | RS $paidAmount ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        backgroundColor: Colors.grey[300],
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              querySnapshot.docs[index].data()['orderStatus'] ==
                                      "ready"
                                  ? Container(
                                      width: size.width,
                                      height: 50,
                                      color: Colors.orange,
                                      child: FlatButton(
                                          onPressed: () {
                                            Navigator
                                                    .of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        FinalCollect(
                                                            cafeCode: querySnapshot
                                                                    .docs[index]
                                                                    .data()[
                                                                'cafeCode'],
                                                            orderID:
                                                                querySnapshot
                                                                    .docs[index]
                                                                    .id,
                                                            userMail: widget
                                                                .user.email,
                                                            date: docName)));
                                          },
                                          child: Text(
                                            "Collect Order",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  : querySnapshot.docs[index].data()['orderStatus'] ==
                                          "rejected"
                                      ? Container(
                                          width: size.width,
                                          height: 50,
                                          color: Colors.black,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Refund Initiated",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : querySnapshot.docs[index]
                                                  .data()['orderStatus'] ==
                                              "accepted"
                                          ? Container(
                                              width: size.width,
                                              height: 50,
                                              color: Colors.red,
                                              child: FlatButton(
                                                onPressed: () {
                                                  FirebaseCallbacks()
                                                      .updateOrderStatus(
                                                          "canceled",
                                                          querySnapshot
                                                                  .docs[index]
                                                                  .data()[
                                                              'cafeCode'],
                                                          querySnapshot
                                                              .docs[index].id,
                                                          widget.user.email,
                                                          docName)
                                                      .then((value) =>
                                                          {setState(() {})});
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          : querySnapshot.docs[index]
                                                      .data()['orderStatus'] ==
                                                  "ordered"
                                              ? Container(
                                                  width: size.width,
                                                  height: 50,
                                                  color: Colors.red,
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      FirebaseCallbacks()
                                                          .updateOrderStatus(
                                                              "canceled",
                                                              querySnapshot.docs[
                                                                          index]
                                                                      .data()[
                                                                  'cafeCode'],
                                                              querySnapshot
                                                                  .docs[index]
                                                                  .id,
                                                              widget.user.email,
                                                              docName)
                                                          .then((value) => {
                                                                setState(() {})
                                                              });
                                                    },
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )
                                              : querySnapshot.docs[index].data()['orderStatus'] ==
                                                      "canceled"
                                                  ? Container(
                                                      width: size.width,
                                                      height: 50,
                                                      color: Colors.black,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Refund Initiated",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  : querySnapshot.docs[index].data()['orderStatus'] ==
                                                          "collected"
                                                      ? Container(
                                                          width: size.width,
                                                          height: 50,
                                                          color: Colors.blue,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text("Collected",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)))
                                                      : Container(
                                                          width: size.width,
                                                          height: 50,
                                                          color: Colors.blue,
                                                          alignment: Alignment.center,
                                                          child: Text("Not Ready Yet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ));
  }
}
