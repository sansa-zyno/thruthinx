import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:truthinx/Services/NotificationServices.dart';

verifyArrival(
    {required BuildContext context,
    required String docId,
    required String modelId,
    required Function setState}) {
  showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.white,
      enableDrag: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.dark(),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                Lottie.network(
                  "https://assets6.lottiefiles.com/packages/lf20_svy4ivvy.json",
                  height: 140,
                ),
                FutureBuilder(
                  future: getLocationName(docId),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == "-1") {
                        return Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Text(
                            "Oops! we can't verify model's location right now.",
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              snapshot.data!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Model has arrived at the above location and is within 150 meters of the radius.",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CupertinoButton.filled(
                                child: Text("Confirm Location"),
                                onPressed: () {
                                  verifyModelLocation(
                                      docId, modelId, context, setState);
                                })
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      });
}

verifyModelLocation(String docId, String modelId, BuildContext context,
    Function setState) async {
  await FirebaseFirestore.instance
      .collection("user")
      .doc(modelId)
      .collection("Bookings")
      .doc(docId)
      .update({"status": "VERIFIED"});
  FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Bookings")
      .doc(docId)
      .update({"status": "VERIFIED"});
  Fluttertoast.showToast(msg: "Model Verified Successfully!");
  setState();

  DocumentSnapshot client = await FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  sendNotifications(
    bodyText:
        "${client["first_name"]}  ${client["last_name"]}, have verified your location.",
    id: modelId,
    title: "Location Verified!",
  );
  Navigator.pop(context);
}

Future<String> getLocationName(docId) async {
  try {
    print("Started");
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Bookings")
        .doc(docId)
        .get();

    print("Got Doc");
    if ((doc.data() as Map<String, dynamic>).containsKey("modelLocation")) {
      GeoPoint gp = doc["modelLocation"];

      print("Got Location");
      String modelAddress = await _getAddress(gp);

      print("got Address");
      return modelAddress;
    } else {
      return "-1";
    }
  } catch (e) {
    //debugPrint(e);
    Fluttertoast.showToast(msg: e.toString());

    return "-1";
  }
}

Future<String> _getAddress(position) async {
  try {
    List<Placemark> p =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = p[0];

    String _modelCurrentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
    return _modelCurrentAddress;
  } catch (e) {
    print(e);
    return "-1";
  }
}
