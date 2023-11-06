import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:truthinx/Models/Gig.dart';
import 'package:truthinx/Services/NotificationServices.dart';
import 'package:truthinx/screens/Dashboard/MyGigs/DescriptionWidget.dart';
import 'package:truthinx/screens/Profile/Instagram/InstagramProfile.dart';

class AllRequests extends StatefulWidget {
  final Gig gig;
  final String docId;
  AllRequests({required this.gig, required this.docId});

  @override
  _AllRequestsState createState() => _AllRequestsState();
}

class _AllRequestsState extends State<AllRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Requests"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Gigs")
            .doc(widget.docId)
            .collection("Proposals")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            int docLength = snapshot.data!.docs.length;
            List<DocumentSnapshot> allDocs = snapshot.data!.docs;
            return ListView(
              children: List.generate(docLength, (index) {
                DocumentSnapshot doc = allDocs[index];
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            /*backgroundImage: doc["modelDp"] == "default"
                                ? AssetImage("assets/userP.png")
                                : NetworkImage(doc["modelDp"]),*/
                          ),
                          title: Text(doc["modelName"]),
                          subtitle: Text(doc["modelEmail"]),
                          trailing: AvatarGlow(
                              animate: true,
                              glowColor: Color(0xFFFFFFFF),
                              endRadius: 30.0,
                              duration: Duration(milliseconds: 2000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 10),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InstagramProfile(
                                                    doc['modelInsta'])
                                            //INsta()
                                            ));
                                  },
                                  child: Image.asset("assets/instagram.png",
                                      height: 32))),
                        ),
                        AnimatedContainer(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          duration: Duration(milliseconds: 600),
                          child: DescriptionTextWidget(text: doc["proposal"]),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
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
                              Text("\$${doc['rate']} / hour")
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    color: Colors.grey[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      height: 60,
                                      child: InkWell(
                                          onTap: () {
                                            acceptOffer(doc);
                                          },
                                          child: Center(
                                              child: Text(
                                            "Accept",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    color: Colors.grey[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      height: 60,
                                      child: InkWell(
                                          onTap: () {
                                            declineOffer(doc);
                                          },
                                          child: Center(
                                              child: Text(
                                            "Decline",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                );
              }),
            );
          } else {
            if (snapshot.connectionState != ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  Lottie.asset("assets/notFound.json"),
                  Text("No Requests found!")
                ],
              );
            } else {
              return Center(
                child: LinearProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }

  acceptOffer(DocumentSnapshot doc) async {
    try {
      String docId = DateTime.now().millisecondsSinceEpoch.toString();
      await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Bookings")
          .doc(docId)
          .set({
        "proposal": doc['proposal'],
        "modelId": doc['modelId'],
        "modelEmail": doc['modelEmail'],
        "modelName": doc['modelName'],
        "order": doc['order'],
        "time": Timestamp.now(),
        "modelDp": doc['modelDp'],
        "rate": doc['rate'],
        "modelInsta": doc['modelInsta'],
        "status": "BOOKED",
        "role": widget.gig.role,
        "title": widget.gig.title,
      });
      await FirebaseFirestore.instance
          .collection("user")
          .doc(doc["modelId"])
          .collection("Bookings")
          .doc(docId)
          .set({
        "status": "BOOKED",
        "time": Timestamp.now(),
        "rate": doc['rate'],
        "role": widget.gig.role,
        "title": widget.gig.title,
        "clientDp": widget.gig.clientDp,
        "clientName": widget.gig.clientName,
        "clientID": widget.gig.clientID,
        "order": doc['order'],
      });

      sendNotifications(
        bodyText:
            "${widget.gig.clientName}, have accepted your proposal as ${widget.gig.role} and ${doc['rate']}/hour.",
        id: doc['modelId'],
        title: "Proposal Accepted",
      );
      FirebaseFirestore.instance.collection("Gigs").doc(docId).delete();

      FirebaseFirestore.instance
          .collection("user")
          .doc(doc["modelId"])
          .collection("ProposalSent")
          .doc(docId)
          .delete();
      Fluttertoast.showToast(
          msg:
              "Offer Accepted!\nYou can track order progress from bookings section.");
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something went wrong! Please try again later");
    }
  }

  declineOffer(DocumentSnapshot doc) async {
    FirebaseFirestore.instance.collection("Gigs").doc(widget.docId).delete();

    FirebaseFirestore.instance
        .collection("user")
        .doc(doc["modelId"])
        .collection("ProposalSent")
        .doc(widget.docId)
        .delete();
    setState(() {});
    Fluttertoast.showToast(msg: "Offer Declined!");
  }
}
