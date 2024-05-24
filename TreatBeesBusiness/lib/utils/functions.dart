import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class FirebaseCallbacks {
  // This functions also creates the owner for the first time
  Future<dynamic> verifyCafe(String code, String email, String msgToken) async {
    HttpsCallable verifyCafe =
        FirebaseFunctions.instance.httpsCallable('verifyCafe');
    return verifyCafe.call([
      {"code": code, "email": email, "msgToken": msgToken}
    ]).then((value) {
      return value.data;
    });
  }

  Future<dynamic> verifyOwner(String email) async {
    HttpsCallable getCurrentUser =
        FirebaseFunctions.instance.httpsCallable('verifyOwner');
    return getCurrentUser.call([
      {"email": email}
    ]).then((value) => value.data);
  }

  Future<dynamic> verifyMenu(String code) async {
    HttpsCallable getCurrentUser =
        FirebaseFunctions.instance.httpsCallable('isMenu');
    return getCurrentUser.call([
      {"cafeCode": code}
    ]).then((value) {
      return value.data;
    });
  }

  Future<dynamic> updateOrderStatus(String status, String code, String orderID,
      String userEmail, String today) async {
    HttpsCallable updateOrder =
        FirebaseFunctions.instance.httpsCallable('updateOrderStatus');
    updateOrder.call([
      {
        "orderStatus": status,
        "cafecode": code,
        "userMail": userEmail,
        "orderID": orderID,
        "today": today,
      }
    ]).then((value) {
      HttpsCallable notify =
          FirebaseFunctions.instance.httpsCallable('sendNotification');

      notify.call([
        {"status": status, "userEmail": userEmail}
      ]).then((value) => {});
      // Call the send Notification function with the status..
      // to Send the notification.
      // It already gets the fcm_token by email of user
      return true;
    });
  }

  Future<dynamic> getMenu(String code) async {
    HttpsCallable getMenu = FirebaseFunctions.instance.httpsCallable('getMenu');
    return getMenu.call([
      {"code": code}
    ]).then((value) => value.data);
  }

  Future<dynamic> saveMenu(List<String> categories,
      List<Map<dynamic, dynamic>> menuItems, String code, bool save) async {
    HttpsCallable saveMenu =
        FirebaseFunctions.instance.httpsCallable('createMenu');
    saveMenu.call([
      {
        "categories": categories,
        "menuItems": menuItems,
        "code": code,
        "save": save
      }
    ]);
  }

  Future<void> updateServices(String code, bool isDelivery, bool isTakeout, bool isPreOrder, bool isOpen){
    HttpsCallable updateService = FirebaseFunctions.instance.httpsCallable('updateServices');
    updateService.call([
      {
        "code":code,
        'isDelivery': isDelivery,
        'isTakeout': isTakeout,
        'isPreOrder':isPreOrder,
        'isOpen':isOpen
      }
    ]);
  }

  Future<dynamic> getCafe(String code){
    HttpsCallable getOneCafe = FirebaseFunctions.instance.httpsCallable('getOneCafe');
    return getOneCafe.call([
      {
        "code": code
      }
    ]).then((value) {
      return value.data;
    });
  }
}
