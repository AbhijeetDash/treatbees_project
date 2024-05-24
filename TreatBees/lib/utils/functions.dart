import 'package:cloud_functions/cloud_functions.dart';

class FirebaseCallbacks {
  Future<bool> createGroup(String groupName, String adminMail) {
    HttpsCallable createGroupCallable = FirebaseFunctions.instance
        .httpsCallable('createGroup', options: HttpsCallableOptions());
    return createGroupCallable
        .call(<Map>[
          {"groupName": groupName, "adminMail": adminMail}
        ])
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<dynamic> getGroups() async {
    HttpsCallable getGroupsCallable =
        FirebaseFunctions.instance.httpsCallable('getGroups');
    return getGroupsCallable.call().then((value) => value.data);
  }

  Future<dynamic> createUser(String email, String name, String phoneNum,
      String address, String msgToken) {
    HttpsCallable createUserCallable =
        FirebaseFunctions.instance.httpsCallable('createUser');
    return createUserCallable.call(<Map>[
      {
        "userEmail": email,
        "userName": name,
        "userPhone": phoneNum,
        "address": address,
        "msgToken": msgToken
      }
    ]);
  }

  Future<dynamic> getCurrentUser(String userMail) {
    HttpsCallable getCurrentUser =
        FirebaseFunctions.instance.httpsCallable('getCurrentUser');
    return getCurrentUser.call([
      {"userMail": userMail}
    ]).then((value) => value.data);
  }

  void placeOrder(
      String docname,
      String userName,
      String userEmail,
      String userPhno,
      String cafecode,
      String time,
      List<Map> orderItems,
      String paymentId,
      String orderType) {
    HttpsCallable placeOrderCallable =
        FirebaseFunctions.instance.httpsCallable('createOrder');
    placeOrderCallable.call(<Map>[
      {
        "today": docname,
        "userName": userName,
        "userMail": userEmail,
        "userPhone": userPhno,
        "cafecode": cafecode,
        "orderItems": orderItems,
        "paymentID": paymentId,
        "orderTime": time,
        "orderStatus": "ordered",
        "orderType": orderType
      }
    ]).then((value) {
      // Call The send notification functions
      HttpsCallable notify =
          FirebaseFunctions.instance.httpsCallable('sendNotificationToOwner');

      notify.call([
        {"status": "Placed", "cafeCode": cafecode}
      ]).then((value) => {});
    });
  }

  Future<dynamic> getCarousels() async {
    HttpsCallable getCarouselCallable =
        FirebaseFunctions.instance.httpsCallable('getCarousels');
    return getCarouselCallable.call().then((value) {
      return value.data;
    });
  }

  Future<dynamic> getTodaysOrders(
    String userEmail,
  ) async {
    DateTime now = DateTime.now();
    String day = '${now.day} : ${now.month} : ${now.year}';
    HttpsCallable currentOrders =
        FirebaseFunctions.instance.httpsCallable('getCurrentOrders');
    return currentOrders.call([
      {"OF": day, "userMail": userEmail}
    ]).then((value) => value.data);
  }

  Future<dynamic> getCafe() async {
    HttpsCallable getAllCafe =
        FirebaseFunctions.instance.httpsCallable('getAllCafe');
    return getAllCafe.call().then((value) {
      return value.data;
    });
  }

  Future<dynamic> getMenu(String code) async {
    HttpsCallable getMenu = FirebaseFunctions.instance.httpsCallable('getMenu');
    return getMenu.call([
      {"code": code}
    ]).then((value) => value.data);
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
      return true;
    });
  }

  Future<dynamic> getOneCafe(String code){
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
