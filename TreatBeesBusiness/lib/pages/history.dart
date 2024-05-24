import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:treatbees_business/utils/theme.dart';
import 'package:treatbees_business/utils/widget.dart';

class History extends StatefulWidget {
  final String code;

  const History({Key key, this.code})
      : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  DateTime selectedDate = DateTime.now().subtract(Duration(hours: 24));
  FirebaseFirestore cloudInstance;
  String selectedMonth = "";
  String selectedDay = "";

  String collectionName = "";

  void generateStringVal(){
    switch(selectedDate.weekday){
      case 1: setState(() {
        selectedDay= "Mon";
      });
      break;
      case 2: setState(() {
        selectedDay= "Tue";
      });
      break;
      case 3: setState(() {
        selectedDay= "Wed";
      });
      break;
      case 4: setState(() {
        selectedDay= "Thu";
      });
      break;
      case 5: setState(() {
        selectedDay= "Fri";
      });
      break;
      case 6: setState(() {
        selectedDay= "Sat";
      });
      break;
      case 7: setState(() {
        selectedDay= "Sun";
      });
      break;
    }

    switch(selectedDate.month){
      case 1: setState(() {
        selectedMonth = "Jan";
      });
      break;
      case 2: setState(() {
        selectedMonth= "Feb";
      });
      break;
      case 3: setState(() {
        selectedMonth= "Mar";
      });
      break;
      case 4: setState(() {
        selectedMonth= "Apr";
      });
      break;
      case 5: setState(() {
        selectedMonth= "May";
      });
      break;
      case 6: setState(() {
        selectedMonth= "Jun";
      });
      break;
      case 7: setState(() {
        selectedMonth= "Jul";
      });
      break;
      case 8: setState(() {
        selectedMonth= "Aug";
      });
      break;
      case 9: setState(() {
        selectedMonth= "Sep";
      });
      break;
      case 10: setState(() {
        selectedMonth= "Oct";
      });
      break;
      case 11: setState(() {
        selectedMonth= "Nov";
      });
      break;
      case 12: setState(() {
        selectedMonth= "Dec";
      });
      break;
    }

    if(selectedDate.day < 10){
      setState(() {
        collectionName = "0"+selectedDate.day.toString()+" : ";
      });
    } else {
      setState(() {
        collectionName = selectedDate.day.toString()+" : ";
      });
    }
    if(selectedDate.month < 10){
      setState(() {
        collectionName += "0"+selectedDate.month.toString()+" : ";
        collectionName += selectedDate.year.toString();
      });
    } else {
      setState(() {
        collectionName += selectedDate.month.toString()+" : ";
        collectionName += selectedDate.year.toString();
      });
    }

    print(collectionName);
  }

  // DatePicker will call this function on every day and expect
  // a bool output. If it's true, it will draw that day as "enabled"
  // and that day will be selectable and vice versa.
  bool _predicate(DateTime day) {
    if (day.isAfter(DateTime(2021, 1, 1))) {
      return true;
    }
    return false;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        selectableDayPredicate: _predicate,
        firstDate: DateTime(2021),
        lastDate: DateTime.now().subtract(Duration(hours: 24)),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
                primaryColor: Colors.orangeAccent,
                disabledColor: Colors.grey,
                textTheme:
                TextTheme(bodyText2: TextStyle(color: Colors.blueAccent)),
                accentColor: Colors.yellow),
            child: child,
          );
        });
    if (picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
      });
      generateStringVal();
    }
  }


  @override
  void initState() {
    cloudInstance = FirebaseFirestore.instance;
    generateStringVal();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().alice,
        elevation: 0.0,
        title: Text("Order History"),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Select date",style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                    RawMaterialButton(
                      fillColor: Colors.orange,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: Text(selectedDay+" "+selectedDate.day.toString()+" "+selectedMonth+" "+selectedDate.year.toString()),
                      ),
                      onPressed: (){
                        _selectDate(context);
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width,
                  height: size.height - 170,
                  color: MyColors().alice,
                  child: StreamBuilder(
                    stream: cloudInstance.collection(widget.code).doc('CafeOrders').collection(collectionName).snapshots(),
                    builder: (context, snapshot){

                      QuerySnapshot querySnapshot = snapshot.data;

                      if(querySnapshot != null){
                        if (querySnapshot.size == 0) {
                          return Center(
                            child: Text(
                              "You do not\nhave any orders for\nthis day.",
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                      return Container(
                        child: ListView.builder(
                            itemCount: querySnapshot.size,
                            itemBuilder: (context, index) {

                              /// Calculating the amount
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

                                        OlderButton(
                                          size: size,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                      } else {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}
