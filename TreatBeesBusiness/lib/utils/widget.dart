import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:treatbees_business/utils/functions.dart';
import 'package:treatbees_business/utils/theme.dart';

class UserAppBarTile extends StatelessWidget {
  final User user;

  /// This widget will take UserName and ProfilePic
  /// link as argumants..
  /// It must be created once and used by Its Object
  /// passed to each node.

  const UserAppBarTile({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'Welcome ',
                style: TextStyle(fontSize: 14, color: Colors.black)),
            TextSpan(
                text: '${user.displayName.split(' ')[0]} ',
                style: MyFonts().smallHeadingLight)
          ]),
        ),
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(user.photoURL),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: 'Treat', style: MyFonts().smallHeadingBold),
        TextSpan(text: 'Bees', style: MyFonts().smallHeadingLight)
      ]),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile(
      {Key key,
      @required this.icon,
      @required this.title,
      @required this.subTitle,
      @required this.onPressed})
      : super(key: key);

  final IconData icon;
  final String title;
  final String subTitle;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Container(
        width: 50,
        height: 50,
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
        child: Icon(icon),
      ),
      title: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(subTitle,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
    );
  }
}

class PreparingButton extends StatefulWidget {
  const PreparingButton(
      {Key key,
      @required this.size,
      @required this.code,
      @required this.docName,
      @required this.querySnapshot,
      @required this.index})
      : super(key: key);

  final Size size;
  final int index;
  final String code;
  final String docName;
  final QuerySnapshot querySnapshot;

  @override
  _PreparingButtonState createState() => _PreparingButtonState();
}

class _PreparingButtonState extends State<PreparingButton> {

  void showStatusUpdateDialoug(BuildContext context){
    Timer(Duration(seconds: 1), (){
      if(Navigator.canPop(context)){
        Navigator.pop(context);
      }
    });
    showDialog(
        context: context,
        barrierDismissible: true,
        child: Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width*0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.0),
                CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.done_all, color: Colors.white,)),
                SizedBox(height: 10.0),
                Text("Status Updated", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                SizedBox(height: 10.0),
                Text("Status of this order\nis updated successfully.", textAlign: TextAlign.center,),
                SizedBox(height: 10.0,),
              ],
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: 50,
      child: FlatButton(
          color: Colors.orangeAccent[700],
          onPressed: () {
            showStatusUpdateDialoug(context);
            FirebaseCallbacks().updateOrderStatus(
                "preparing",
                widget.code,
                widget.querySnapshot.docs[widget.index].id,
                widget.querySnapshot.docs[widget.index].data()['orderBy'],
                widget.docName).then((value){

            });
          },
          child: Text("Update to Preparing")),
    );
  }
}

class ReadyButton extends StatefulWidget {
  const ReadyButton(
      {Key key,
      @required this.size,
      @required this.code,
      @required this.docName,
      @required this.querySnapshot,
      @required this.index})
      : super(key: key);

  final Size size;
  final int index;
  final String code;
  final String docName;
  final QuerySnapshot querySnapshot;

  @override
  _ReadyButtonState createState() => _ReadyButtonState();
}

class _ReadyButtonState extends State<ReadyButton> {

  void showStatusUpdateDialoug(BuildContext context){
    Timer(Duration(seconds: 1), (){
      if(Navigator.canPop(context)){
        Navigator.pop(context);
      }
    });
    showDialog(
        context: context,
        barrierDismissible: true,
        child: Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width*0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.0),
                CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.done_all, color: Colors.white,)),
                SizedBox(height: 10.0),
                Text("Status Updated", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                SizedBox(height: 10.0),
                Text("Status of this order\nis updated successfully.", textAlign: TextAlign.center,),
                SizedBox(height: 10.0,),
              ],
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: 50,
      child: FlatButton(
          color: Colors.green,
          onPressed: () {
            showStatusUpdateDialoug(context);
            FirebaseCallbacks().updateOrderStatus(
                "ready",
                widget.code,
                widget.querySnapshot.docs[widget.index].id,
                widget.querySnapshot.docs[widget.index].data()['orderBy'],
                widget.docName);
          },
          child: Text("Order is Ready")),
    );
  }
}

class CompleteButton extends StatelessWidget {
  const CompleteButton({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: 50,
      color: Colors.grey[900],
      alignment: Alignment.center,
      child: Text(
        "Waiting for Pickup",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class OlderButton extends StatelessWidget {
  const OlderButton({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: 50,
      color: Colors.grey[400],
      alignment: Alignment.center,
      child: Text(
        "Older Order",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class AcceptRejectButtons extends StatefulWidget {
  const AcceptRejectButtons(
      {Key key,
      @required this.code,
      @required this.querySnapshot,
      @required this.index,
      @required this.docName})
      : super(key: key);

  final String code;
  final String docName;
  final int index;
  final QuerySnapshot querySnapshot;

  @override
  _AcceptRejectButtonsState createState() => _AcceptRejectButtonsState();
}

class _AcceptRejectButtonsState extends State<AcceptRejectButtons> {

  void showStatusUpdateDialoug(BuildContext context){
    Timer(Duration(seconds: 1), (){
      Navigator.pop(context);
    });
    showDialog(
        context: context,
        barrierDismissible: true,
        child: Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width*0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.0),
                CircleAvatar(
                  backgroundColor: Colors.green,
                    child: Icon(Icons.done_all, color: Colors.white,)),
                SizedBox(height: 10.0),
                Text("Status Updated", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                SizedBox(height: 10.0),
                Text("Status of this order\nis updated successfully.", textAlign: TextAlign.center,),
                SizedBox(height: 10.0,),
              ],
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RawMaterialButton(
          onPressed: () {
            // Update Order Status to Rejected
            showStatusUpdateDialoug(context);
            FirebaseCallbacks().updateOrderStatus(
                "rejected",
                widget.code,
                widget.querySnapshot.docs[widget.index].id,
                widget.querySnapshot.docs[widget.index].data()['orderBy'],
                widget.docName);
          },
          shape: StadiumBorder(),
          fillColor: Colors.orange,
          child: Text("Reject"),
        ),
        SizedBox(width: 20),
        RawMaterialButton(
          onPressed: () {
            showStatusUpdateDialoug(context);
            // Update Order Status to Accepted
            FirebaseCallbacks().updateOrderStatus(
                "accepted",
                widget.code,
                widget.querySnapshot.docs[widget.index].id,
                widget.querySnapshot.docs[widget.index].data()['orderBy'],
                widget.docName).then((value){

            });
          },
          shape: StadiumBorder(),
          fillColor: Colors.orange,
          child: Text("Accept"),
        ),
      ],
    );
  }
}
