import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:truthinx/Services/NotificationServices.dart';
import 'package:truthinx/screens/Dashboard/Maps/MapView.dart';
import 'BookingModalForModel.dart';

class ModelBookingCard extends StatefulWidget {
  final BookingModalForModel bm;

  final String docId;
  final int totalBookings;
  final int bookingIndex;
  ModelBookingCard(
      {required this.bm,
      required this.totalBookings,
      required this.bookingIndex,
      required this.docId});

  @override
  _ModelBookingCardState createState() => _ModelBookingCardState();
}

class _ModelBookingCardState extends State<ModelBookingCard> {
  var kInitialPosition = LatLng(-33.8567844, 151.213108);

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      print("Got user Location");
      kInitialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  String address = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.grey[600],
              child: Container(
                child: ListView(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        /*backgroundImage: widget.bm.clientDp == "default"
                            ? AssetImage("assets/userP.png")
                            : NetworkImage(widget.bm.clientDp),*/
                        backgroundColor: Colors.grey[200],
                        radius: 25,
                      ),
                      title: Text(widget.bm.clientName!),
                      subtitle: Text("Client"),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Image.asset(
                                  "assets/role.png",
                                  height: 24,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text("Title:"),
                              SizedBox(width: 10),
                              Text(widget.bm.title!),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Image.asset(
                                  "assets/role.png",
                                  height: 24,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text("Role:"),
                              SizedBox(width: 10),
                              Text(widget.bm.role!)
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Image.asset(
                                  "assets/coin-stack.png",
                                  height: 24,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text("Budget:"),
                              SizedBox(width: 10),
                              Text("\$${widget.bm.rate} / hour")
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      indent: 40,
                      endIndent: 12,
                      thickness: 2,
                    ),
                    ListTile(
                      leading: Icon(Icons.date_range_rounded),
                      title: Text("Booked on"),
                      subtitle: Text(DateFormat(DateFormat.YEAR_MONTH_DAY)
                          .format(widget.bm.time!.toDate())),
                    ),
                    Divider(
                      indent: 40,
                      endIndent: 12,
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  child: widget.bm.status == 'BOOKED' ||
                                          widget.bm.status == "SENT" ||
                                          widget.bm.status == "VERIFIED"
                                      ? Icon(Icons.check)
                                      : Container()),
                              SizedBox(width: 10),
                              Text("Project Started"),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: SizedBox(
                              height: 10,
                              width: 2,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  child: widget.bm.status == "SENT" ||
                                          widget.bm.status == "VERIFIED"
                                      ? Icon(Icons.check)
                                      : Container()),
                              SizedBox(width: 10),
                              Text("Location Recieved"),
                              Expanded(
                                child: Container(),
                              ),
                              Visibility(
                                  visible: widget.bm.status == "BOOKED",
                                  child: Icon(Icons.arrow_forward_ios_rounded))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: SizedBox(
                              height: 10,
                              width: 2,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap:
                                //sendArrivalNotification,
                                () async {
                              if (widget.bm.status == "SENT") {
                                DocumentSnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection("user")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("Bookings")
                                    .doc(widget.docId)
                                    .get();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapView(
                                      destination: snap["location"],
                                      docId: widget.docId,
                                      clientID: widget.bm.clientID!,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child: widget.bm.status == "VERIFIED"
                                        ? Icon(Icons.check)
                                        : Container()),
                                SizedBox(width: 10),
                                Text("Verify your arrival"),
                                Expanded(
                                  child: Container(),
                                ),
                                Visibility(
                                    visible: widget.bm.status != "VERIFIED",
                                    child:
                                        Icon(Icons.arrow_forward_ios_rounded))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          height: 60,
                          child: InkWell(
                              onTap: () async {
                                if (widget.bm.status != "VERIFIED") {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Project can not be marked as complete, Because pre-requisites are not completed.",
                                      toastLength: Toast.LENGTH_LONG);
                                  return;
                                }
                                DocumentSnapshot model = await FirebaseFirestore
                                    .instance
                                    .collection("user")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get();

                                sendNotifications(
                                  bodyText:
                                      "${model["first_name"]}  ${model["last_name"]}, have requested for payment. Please mark the respected project as complete.",
                                  id: widget.bm.clientID,
                                  title: "Payment Request!",
                                );
                              },
                              child: Center(
                                  child: Text(
                                "Request Payment",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text("${widget.bookingIndex}/${widget.totalBookings}"),
        ],
      ),
    );
  }
}
