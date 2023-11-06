import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:truthinx/Models/Proposal.dart';
import 'package:truthinx/Services/NotificationServices.dart';
import 'package:truthinx/screens/Dashboard/MyGigs/DescriptionWidget.dart';

class ModelProposalCard extends StatelessWidget {
  final ModelProposal? proposal;
  final int? totalProposals;
  final int? proposalIndex;
  final String docId;
  ModelProposalCard(
      {this.proposal,
      this.proposalIndex,
      this.totalProposals,
      required this.docId});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.grey[600],
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      // backgroundImage: proposal.clientDP == "default" ? AssetImage("assets/userP.png") : NetworkImage(proposal.clientDP),
                      backgroundColor: Colors.grey[200],
                      radius: 25,
                    ),
                    title: Text(proposal!.clientName),
                    subtitle: Text(DateFormat(DateFormat.YEAR_MONTH_DAY)
                        .format(proposal!.time.toDate())),
                  ),
                  AnimatedContainer(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: Duration(milliseconds: 600),
                    child: DescriptionTextWidget(text: proposal!.proposal),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
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
                        Text("\$${proposal!.rate} / hour")
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                height: 60,
                                child: InkWell(
                                    onTap: () {
                                      acceptOffer(docId);
                                    },
                                    child: Center(
                                        child: Text(
                                      "Connect",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                height: 60,
                                child: InkWell(
                                    onTap: () {
                                      declineOffer(docId);
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
          ),
          SizedBox(
            height: 5,
          ),
          Text("$proposalIndex/$totalProposals")
        ],
      ),
    );
  }

  acceptOffer(String docId) async {
    try {
      DocumentSnapshot model = await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      String rate = proposal!.rate.toString();
      await FirebaseFirestore.instance
          .collection("user")
          .doc(proposal!.clientId)
          .collection("Bookings")
          .doc(docId)
          .set({
        "proposal": proposal!.proposal,
        "modelId": FirebaseAuth.instance.currentUser!.uid,
        "modelEmail": model["email"],
        "modelName": "${model['first_name']} ${model["last_name"]}",
        "order": DateTime.now().microsecondsSinceEpoch,
        "time": Timestamp.now(),
        "modelDp": model['dp'],
        "rate": rate,
        "modelInsta": model['instagram_username'],
        "status": "BOOKED",
        "role": "Model",
        "title": "Unknown",
      });
      await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Bookings")
          .doc(docId)
          .set({
        "status": "BOOKED",
        "time": Timestamp.now(),
        "rate": rate,
        "role": "Model",
        "title": "Unknown",
        "clientDp": proposal!.clientDP,
        "clientName": proposal!.clientName,
        "clientID": proposal!.clientId,
        "order": DateTime.now().microsecondsSinceEpoch,
      });
      sendNotifications(
        bodyText:
            "${model["first_name"]}  ${model["last_name"]}, have accepted your proposal.",
        id: proposal!.clientId,
        title: "Congratulations!",
      );
      FirebaseFirestore.instance
          .collection("user")
          .doc(proposal!.clientId)
          .collection("MyProposals")
          .doc(docId)
          .delete();

      FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("MyProposals")
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

  declineOffer(String docId) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(proposal!.clientId)
        .collection("MyProposals")
        .doc(docId)
        .delete();

    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("MyProposals")
        .doc(docId)
        .delete();
    Fluttertoast.showToast(msg: "Offer Declined!");
  }
}
