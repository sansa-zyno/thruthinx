import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:truthinx/Services/NotificationServices.dart';
import 'package:truthinx/Services/ProfileServices.dart';

import 'package:truthinx/Models/AppUser.dart';
import 'package:truthinx/screens/Dashboard/ModelHire/ModelAttributes.dart';
import 'package:truthinx/screens/Dashboard/ModelHire/ModelCategories.dart';
import 'package:truthinx/screens/Dashboard/ModelHire/ModelSkills.dart';
import 'package:truthinx/screens/Dashboard/ModelHire/Portfolio.dart';
import 'package:truthinx/screens/Profile/Instagram/InstaProfileWebView.dart';
import 'package:truthinx/screens/Widgets/RoundedTabBarIndicator.dart';

class ModelDetails extends StatefulWidget {
  final DocumentSnapshot modelDetail;
  final bool isClient;
  ModelDetails({required this.modelDetail, required this.isClient});

  @override
  _ModelDetailsState createState() => _ModelDetailsState();
}

class _ModelDetailsState extends State<ModelDetails> {
  TextEditingController _proposalController = TextEditingController();
  ProfileServices profileData = ProfileServices();
  AppUser? user;
  @override
  void dispose() {
    _proposalController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        backgroundColor: Color(0xFF28201A),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: Color(0xFFA66234),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ]),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: AvatarGlow(
                              animate: true,
                              glowColor: Color(0xFFA66234),
                              endRadius: 90.0,
                              duration: Duration(milliseconds: 2000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 10),
                              child: Hero(
                                tag: widget.modelDetail.hashCode,
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundImage: widget.modelDetail["dp"] ==
                                          "default"
                                      ? AssetImage('assets/userP.png')
                                      : NetworkImage(widget.modelDetail["dp"])
                                          as ImageProvider,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Center()),
                      ],
                    ),
                  ),
                  Text(
                    "${widget.modelDetail["first_name"]}  ${widget.modelDetail["last_name"]}"
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: GoogleFonts.varelaRound().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5),
                  widget.modelDetail["verification"] == "VERIFIED"
                      ? Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on_rounded,
                                      color: Color(0xFF7C7671)),
                                  SizedBox(width: 5),
                                  Text(
                                    widget.modelDetail["city"],
                                    style: TextStyle(
                                      color: Color(0xFF7C7671),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: widget.isClient,
                                    child: Card(
                                      color: Color(0xFFF08740),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        height: 50,
                                        child: InkWell(
                                            onTap: () {
                                              openProposal();
                                            },
                                            child: Center(
                                              child: Text(
                                                  "\$${widget.modelDetail["hourlyRate"]}/hr",
                                                  style: TextStyle(
                                                      fontFamily: GoogleFonts
                                                              .varelaRound()
                                                          .fontFamily)),
                                            )),
                                      ),
                                    ),
                                  ),
                                  AvatarGlow(
                                    animate: true,
                                    glowColor: Color(0xFFA66234),
                                    endRadius: 30.0,
                                    duration: Duration(milliseconds: 2000),
                                    repeat: true,
                                    showTwoGlows: true,
                                    repeatPauseDuration:
                                        Duration(milliseconds: 10),
                                    child: IconButton(
                                        icon: Image.asset(
                                          "assets/instagram.png",
                                          height: 24,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      InstaProfileWebView(
                                                          "https://www.instagram.com/${widget.modelDetail["instagram_username"]}/")));
                                        }),
                                  ),
                                ],
                              ),
                              TabBar(
                                indicatorSize: TabBarIndicatorSize.values[1],
                                isScrollable: true,
                                //indicatorPadding: EdgeInsets.only(right: 40),
                                indicatorColor: Colors.white,
                                indicator: RoundUnderlineTabIndicator(
                                    borderSide: BorderSide(
                                      width: 3.5,
                                      color: Color(0xFFF08740),
                                    ),
                                    insets: EdgeInsets.only(right: 25)),

                                tabs: [
                                  Tab(
                                    child: Row(
                                      children: [Text("Portfolio")],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      children: [Text("Categories")],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      children: [Text("Attributes")],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      children: [Text("Skills")],
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: TabBarView(children: [
                                  Portfolio(
                                    bestPhotos:
                                        widget.modelDetail["bestPhotos"],
                                  ),
                                  ModelCategories(
                                      categories:
                                          widget.modelDetail["categories"]),
                                  ModelAttributes(
                                    attributes:
                                        widget.modelDetail["attributes"],
                                  ),
                                  ModelSkills(
                                    skills: widget.modelDetail["skills"],
                                  ),
                                ]),
                              )
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Divider(),
                            Card(
                              color: Color(0xFFF08740),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.verified_user_outlined),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("User not verified!")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void openProposal() {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
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
                          child: Text("Proposal",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily:
                                    GoogleFonts.varelaRound().fontFamily,
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
                      height: MediaQuery.of(context).size.height * 0.35,
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
                          controller: _proposalController,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Send Custom Proposal"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 10),
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
                          Text("\$${widget.modelDetail["hourlyRate"]} / hour")
                        ],
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
                                      fontFamily: GoogleFonts.varelaRound()
                                          .fontFamily)),
                            )),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                )),
          );
        });
  }

  void sendProposal() async {
    if (_proposalController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please write a custom Offer");
      return;
    }
    user = await profileData.getLocalUser();
    String docId = DateTime.now().millisecondsSinceEpoch.toString();
    DocumentSnapshot client = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    FirebaseFirestore.instance
        .collection("user")
        .doc(widget.modelDetail.id)
        .collection("MyProposals")
        .doc(docId)
        .set({
      "proposal": _proposalController.text,
      "clientId": FirebaseAuth.instance.currentUser!.uid,
      "clientEmail": user!.email,
      "clientName": "${user!.first_name} ${user!.last_name}",
      "order": DateTime.now().millisecondsSinceEpoch,
      "time": Timestamp.now(),
      "clientDP": client["dp"],
      "rate": widget.modelDetail["hourlyRate"],
    });
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("MyProposals")
        .doc(docId)
        .set({
      "proposal": _proposalController.text,
      "modelId": widget.modelDetail.id,
      "modelEmail": widget.modelDetail["email"],
      "modelName":
          "${widget.modelDetail["first_name"]}  ${widget.modelDetail["last_name"]}",
      "order": DateTime.now().millisecondsSinceEpoch,
      "time": Timestamp.now(),
      "modelDp": widget.modelDetail["dp"],
      "rate": widget.modelDetail["hourlyRate"],
    });

    sendNotifications(
      bodyText:
          "${user!.first_name} ${user!.last_name}, have sent you a proposal, please visit My Proposals section to track it.",
      id: widget.modelDetail.id,
      title: "Mew Project!",
    );
    Fluttertoast.showToast(msg: "Proposal sent!");
    Navigator.pop(context);
    _proposalController.clear();
  }
}
