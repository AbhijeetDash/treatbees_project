import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:treatbees_business/utils/theme.dart';

class Completed extends StatefulWidget {
  final String date;
  final String code;
  final String docName;

  const Completed({Key key, this.date, this.code, this.docName})
      : super(key: key);

  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().alice,
        elevation: 0.0,
        title: Text("Completed Orders"),
      ),
      body: Container(
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
                        text: widget.date, style: MyFonts().smallHeadingBold),
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
                        .collection(widget.code)
                        .doc('CafeOrders')
                        .collection(widget.docName)
                        .where('orderStatus', isEqualTo: "collected")
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
                              "You have no\ncompleted any orders",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      return Container(
                        height: size.height * 0.8,
                        child: ListView.builder(
                            itemCount: querySnapshot.size,
                            itemBuilder: (context, index) {
                              int paidAmount = 0;
                              querySnapshot.docs[index]
                                  .data()['orderItems']
                                  .forEach((item) => {
                                        paidAmount +=
                                            int.parse(item['TotalPrice'])
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                          fontWeight: FontWeight.bold,
                                                          backgroundColor: Colors.black,
                                                        ))
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
                                        Container(
                                          width: size.width,
                                          height: 50,
                                          color: Colors.green[900],
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Order Collected",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
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
          )),
    );
  }
}
