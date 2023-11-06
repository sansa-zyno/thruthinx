import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  // static String appName = "AshabulHadith";
  // static String applink = "https://ashabulhadith.com";

  static final Color maincolor = Color.fromRGBO(143, 148, 251, 1);
  static final Color green = Colors.green;

  static int gender = -1;
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
String getRandomString(int length) {
  Random _rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

final postNotificationURL = "https://fcm.googleapis.com/fcm/send";
final headers = {
  'content-type': 'application/json',
  'Authorization': dotenv.env["authServerKeyFirebase"]!
};
List<String> categories = [
  "Advertising/Marketing",
  "Artist",
  "Apparel/Accessories",
  "Automotive",
  "Beauty",
  "Cosmetics/Fragrances",
  "Designer",
  "E-commerce",
  "Education",
  "Electronics",
  "Events",
  "Film/TV/Cable",
  "Financial",
  "Food/Beverage",
  "Haircare",
  "Health/Fitness",
  "Home/Furniture",
  "Hospitality/Hotel",
  "Hotel/Resort",
  "Industrial",
  "Makeup Artist",
  "Medical",
  "Music",
  "Other",
  "Photographer",
  "Publication",
  "Real Estate",
  "Retail",
  "Skincare",
  "Spa",
  "Sports",
  "Stylist",
  "Technology",
  "Travel",
  "Videographer",
];

List<int> categoryIndex = [
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
];
