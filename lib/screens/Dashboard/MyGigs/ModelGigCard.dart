import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:truthinx/Services/ProfileServices.dart';
import 'package:truthinx/Models/AppUser.dart';
import 'package:truthinx/Models/Gig.dart';
import 'package:truthinx/screens/Dashboard/MyGigs/DescriptionWidget.dart';
import '../../../Services/NotificationServices.dart';

class ModelGigCard extends StatefulWidget {
  final Gig gig;
  final String docId;
  final int totalProposals;
  final int proposalIndex;
  ModelGigCard(
      {required this.gig,
      required this.proposalIndex,
      required this.totalProposals,
      required this.docId});

  @override
  _ModelGigCardState createState() => _ModelGigCardState();
}

class _ModelGigCardState extends State<ModelGigCard> {
  TextEditingController _gigRequestController = TextEditingController();
  TextEditingController hourlyrate = TextEditingController();

  ProfileServices profileData = ProfileServices();
  AppUser? user;
  @override
  void dispose() {
    _gigRequestController.dispose();

    super.dispose();
  }

  void initState() {
    super.initState();
    profileData.getLocalUser().then((value) {
      setState(() {
        user = value;
        print(user!.instagram);
      });
    });
  }

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
                        /*backgroundImage: widget.gig.clientDp == "default"
                            ? AssetImage("assets/userP.png")
                            : NetworkImage(widget.gig.clientDp),*/
                        backgroundColor: Colors.grey[200],
                        radius: 25,
                      ),
                      title: Text(widget.gig.clientName),
                      subtitle: Text(DateFormat(DateFormat.YEAR_MONTH_DAY)
                          .format(widget.gig.dateCreated.toDate())),
                    ),
                    AnimatedContainer(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: Duration(milliseconds: 600),
                      child: DescriptionTextWidget(text: widget.gig.desc),
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
                              Text("Role:"),
                              SizedBox(width: 10),
                              Text(widget.gig.role)
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Image.asset(
                                  "assets/gender.png",
                                  height: 24,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text("Gender:"),
                              SizedBox(width: 10),
                              Text(widget.gig.gender),
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
                              Text("\$${widget.gig.hourlyRate} / hour")
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
                    AnimatedContainer(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: Duration(milliseconds: 600),
                      child: DescriptionTextWidget(
                          text: "Requirements:\n\n${widget.gig.requirements}"),
                    ),
                    FutureBuilder(
                        future: checkAlreadyApplied(),
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            print("APPLIED : ${snapshot.data}");
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 60,
                                  child: InkWell(
                                      onTap: !snapshot.data!
                                          ? () {
                                              openApplyGigPanel();
                                            }
                                          : null,
                                      child: Center(
                                          child: Text(
                                        !snapshot.data! ? "Apply" : "Applied",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text("${widget.proposalIndex}/${widget.totalProposals}")
        ],
      ),
    );
  }

  Future<bool> checkAlreadyApplied() async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance
          .collection("Gigs")
          .doc(widget.docId)
          .collection("Proposals")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });

      return exists;
    } catch (e) {
      return false;
    }
  }

  void openApplyGigPanel() async {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              decoration: BoxDecoration(
                color: Color(0xFF28201A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Send Request",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.varelaRound().fontFamily,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(DateFormat(DateFormat.YEAR_MONTH_DAY)
                            .format(DateTime.now())),
                      )
                    ],
                  ),
                  AnimatedContainer(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF3d2514),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: Duration(milliseconds: 600),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _gigRequestController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Send Custom Proposal"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Card(
                      color: Color(0xFF3d2514),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: TextField(
                            controller: hourlyrate,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefix: Text("\$  "),
                                suffix: Text('/ hour'),
                                border: InputBorder.none,
                                hintText: "Hourly Rate"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: Color(0xFFF08740),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 50,
                      child: InkWell(
                          onTap: () {
                            sendProposal();
                          },
                          child: Center(
                            child: Text("Send",
                                style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.varelaRound().fontFamily)),
                          )),
                    ),
                  ),
                ],
              ));
        });
  }

  void sendProposal() async {
    if (_gigRequestController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please write a custom Offer");
      return;
    }
    if (hourlyrate.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please define an hourly rate");
      return;
    }
    // user = await profileData.getLocalUser();
    DocumentSnapshot model = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    // FirebaseFirestore.instance.collection("user").doc(widget.gig.clien).collection("MyProposals").doc().set({
    //   "proposal" : _gigRequestController.text,
    //   "clientId" : FirebaseAuth.instance.currentUser.uid,
    //   "clientEmail" : user.email,
    //   "clientName": "${user.first_name} ${user.last_name}",
    //   "order": DateTime.now().millisecondsSinceEpoch,
    //   "time":Timestamp.now(),
    //   "clientDP": client["dp"],

    FirebaseFirestore.instance
        .collection("Gigs")
        .doc(widget.docId)
        .collection("Proposals")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "proposal": _gigRequestController.text,
      "modelId": FirebaseAuth.instance.currentUser!.uid,
      "modelEmail": FirebaseAuth.instance.currentUser!.email,
      "modelName": "${model["first_name"]}  ${model["last_name"]}",
      "order": DateTime.now().millisecondsSinceEpoch,
      "time": Timestamp.now(),
      "modelDp": model["dp"],
      "rate": hourlyrate.text,
      "modelInsta": model["instagram_username"]
    });
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("ProposalSent")
        .doc(widget.docId)
        .set({
      "proposalID": widget.docId,
    });
    sendNotifications(
      bodyText:
          "You have recieved a request from ${model["first_name"]}  ${model["last_name"]}, on your gig.",
      id: widget.gig.clientID,
      title: "New Proposal!",
    );
    Fluttertoast.showToast(msg: "Proposal sent!");
    _gigRequestController.clear();
    hourlyrate.clear();
    Navigator.pop(context);
  }
}
