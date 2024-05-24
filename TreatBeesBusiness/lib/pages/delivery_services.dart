import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treatbees_business/utils/functions.dart';
import 'package:treatbees_business/utils/theme.dart';

class ServiceEdit extends StatefulWidget {
  final String date;
  final String code;
  final String docName;
  const ServiceEdit(
      {Key key,
        @required this.date,
        @required this.code,
        @required this.docName})
      : super(key: key);
  @override
  _ServiceEditState createState() => _ServiceEditState();
}

class _ServiceEditState extends State<ServiceEdit> {

  bool isDelivery = true;
  bool isTakeout = true;
  bool isPreOrder = true;
  bool isOpen = true;
  TextEditingController _controller;
  FirebaseFirestore cloudInstance;

  @override
  void initState() {
    cloudInstance = FirebaseFirestore.instance;
    FirebaseCallbacks().getCafe(widget.code).then((value){
      setState(() {
        isDelivery = value['isDelivery'];
        isTakeout = value['isTakeout'];
        isPreOrder = value['isPreOrder'];
        isOpen = value['isOpen'];
      });
    });
    _controller = TextEditingController();
    super.initState();
  }

  void showInvalidAmount(BuildContext context, String valInfo){
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
              Text(valInfo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              SizedBox(height: 10.0),
              Text("Enter a value in\nrange of 0 to 200", textAlign: TextAlign.center,),
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

  void showSuccess(BuildContext context){
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
                Text("Success", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                SizedBox(height: 10.0),
                Text("Value Updated Successfully", textAlign: TextAlign.center,),
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().alice,
        elevation: 0.0,
        title: Text("Edit Services"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: MyColors().alice,
        padding: EdgeInsets.only(left: 15.0),
        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text("Please Enable all the services that you can provide.", style: Theme.of(context).textTheme.subtitle2,),
                SizedBox(height: 10,),
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
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
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "Delivery",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Container(
                            height: 25,
                            child: Switch(
                                value: isDelivery,
                                onChanged: (val) {
                                  setState(() {
                                    isDelivery = val;
                                  });
                                  FirebaseCallbacks().updateServices(widget.code, isDelivery, isTakeout, isPreOrder, isOpen);
                                }),
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "Pre-order",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Container(
                            height: 25,
                            child: Switch(
                                value: isPreOrder,
                                onChanged: (val) {
                                  setState(() {
                                    isPreOrder = val;
                                  });
                                  FirebaseCallbacks().updateServices(widget.code, isDelivery, isTakeout, isPreOrder, isOpen);
                                }),
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "Take out",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Container(
                            height: 25,
                            child: Switch(
                                value: isTakeout,
                                onChanged: (val) {
                                  setState(() {
                                    isTakeout = val;
                                  });
                                  FirebaseCallbacks().updateServices(widget.code, isDelivery, isTakeout, isPreOrder, isOpen);
                                }),
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "Store is Open",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Container(
                            height: 25,
                            child: Switch(
                                value: isOpen,
                                onChanged: (val) {
                                  setState(() {
                                    isOpen = val;
                                  });
                                  FirebaseCallbacks().updateServices(widget.code, isDelivery, isTakeout, isPreOrder, isOpen);
                                }),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Text("Minimum Order Amount", style: Theme.of(context).textTheme.subtitle2,),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
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
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter the amount",
                              helperText: "This is the minimum order amount you can deliver\nMust be <= 200"
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        SizedBox(height: 10.0,),
                        RawMaterialButton(
                          onPressed: (){
                            if(_controller.text != ""){
                              int amount = int.parse(_controller.text);
                              if(amount > 200) {
                                showInvalidAmount(context, "Value too high");
                                setState(() {
                                  _controller.text = "";
                                });
                              } else if(amount < 0) {
                                showInvalidAmount(context, "Value too low");
                                setState(() {
                                  _controller.text = "";
                                });
                              } else {
                                cloudInstance.collection(widget.code).doc('INFO').update(
                                    {
                                        "MinOrderAmount": amount
                                    }).then((value){
                                        setState(() {
                                          _controller.text = "";
                                        });
                                        showSuccess(context);
                                    });
                              }
                            } else {
                              showInvalidAmount(context, "Empty Value");
                              setState(() {
                                _controller.text = "";
                              });
                            }
                          },
                          fillColor: Colors.orange,
                          child: Text("Update", style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),
                )
              ],
        ),
      ),
    );
  }
}
//
// class ServiceEditSwitch extends StatefulWidget {
//
//   final bool avai;
//   final String code;
//   final String serviceType;
//   const ServiceEditSwitch({Key key, this.avai, this.code, this.serviceType}) : super(key: key);
//
//   @override
//   _ServiceEditSwitchState createState() => _ServiceEditSwitchState();
// }
//
// class _ServiceEditSwitchState extends State<ServiceEditSwitch> {
//
//   bool currValue = false;
//
//   @override
//   void initState() {
//     setState(() {
//       currValue = widget.avai;
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }