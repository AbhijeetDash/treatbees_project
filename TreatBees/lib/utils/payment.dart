import 'package:TreatBees/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payments {
  Razorpay _razorpay;
  String userEmail, cafecode, time, userPhno, userName, docName, type;
  List<Map<String, dynamic>> orderItems = [];
  String paymentId;
  BuildContext context;

  Payments(String docName, String userName, String userEmail, String cafecode,
      String time, String userPhno, List<Map<String, dynamic>> orderItems, BuildContext context, String type) {
    this.docName = docName;
    this.userName = userName;
    this.userEmail = userEmail;
    this.cafecode = cafecode;
    this.time = time;
    this.orderItems = orderItems;
    this.userPhno = userPhno;
    this.context = context;
    this.type = type;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> createOrder(
    int amount,
    String uName,
    String uEmail,
    String userPhone,
  ) {
    var options = {
      'key': 'rzp_test_qZ6mpIbWNzYTaI',
      'amount': amount,
      'name': uName,
      'description': 'Payment',
      'prefill': {'email': uEmail, "phone": userPhone},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Add Order to the database with payment status..
    // cafecode would be cafeID in the form of cafecode@TBID
    FirebaseCallbacks().placeOrder(docName, userName, userEmail, userPhno,
        cafecode, time, orderItems, response.paymentId, type);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20),
      child: Text("Payment Failed! try again later"),
    )));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // handle error and success and do the same as Success and Error
  }
}
