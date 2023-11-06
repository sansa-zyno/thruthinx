import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:truthinx/utils/constants.dart';

void sendNotifications({String? bodyText, String? title, String? id}) async {
  String token = "";
  DocumentSnapshot doc;
  try {
    doc = await FirebaseFirestore.instance
        .collection("notifications")
        .doc(id)
        .get();
    token = doc["fcmToken"];
  } catch (e) {
    print(e);
  }

  final body = {
    "to": token,
    "collapse_key": "type_a",
    "notification": {
      "title": title,
      "body": bodyText,
    },
  };

  var url = Uri.parse(postNotificationURL);
  print(url);
  final response = await http.post(url,
      body: json.encode(body),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
    print('test ok push CFM');
  } else {
    print(response.statusCode);
    print(' CFM error');
  }
}
