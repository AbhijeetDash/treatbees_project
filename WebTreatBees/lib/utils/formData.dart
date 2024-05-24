import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Selections {
  //Basic Details
  String restaurantName;
  String ownerName;
  String city;
  String ownerEmail;
  String ownewOrNot;
  String ownerPhone;

  // Location Details

  String adsL1;
  String adsL2;
  String adsLMark;
  String restoPhone;

  // Services Details

  List<String> serviceType = [];
  String seating;

  // Timing
  List<Map<String, String>> daytime = [];

  // Cafe Code Prime
  String createCode() {
    int nameLength = restaurantName.length - 1;
    int mean = (nameLength / 2).round();
    if (restaurantName[mean] == " ") {
      mean++;
    }
    String nameCode = restaurantName[0] +
        '' +
        restaurantName[mean] +
        '' +
        restaurantName[nameLength];

    String numCode = restoPhone.substring(5, 9);

    String code = nameCode.toUpperCase() + '' + numCode;
    return code;
  }

  Future<bool> createCafe() async {
    String code = createCode();
    FirebaseFirestore store = FirebaseFirestore.instance;
    return store.collection('$code').doc("INFO").set({
      "#VerificationStatus": "Unverified",
      "#CafeCode": code,
      //
      "RestaurantName": restaurantName,
      "OwnerName": ownerName,
      "POCDesignation": ownewOrNot,
      "OwnerPhone": ownerPhone,
      "OwnerEmail": ownerEmail,
      //
      "City": city,
      "AddressLine1": adsL1,
      "AddressLine2": adsL2,
      "Landmart": adsLMark,
      "RestaurantPhone": restoPhone,
      //
      "ServiceType": serviceType,
      "Seating": seating,
      //
      "Timing": daytime,
      "isPreOrder": true,
      "isDelivery": true,
      "isTakeout": true
    }).then((value) {
      return true;
    });
  }
}
