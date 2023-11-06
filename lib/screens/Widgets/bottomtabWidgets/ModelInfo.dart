import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/Models/verification/verification_model1.dart';
import 'package:truthinx/utils/constants.dart';

class ModelInfo extends StatefulWidget {
  ModelInfo({Key? key}) : super(key: key);

  @override
  _ModelInfoState createState() => _ModelInfoState();
}

class _ModelInfoState extends State<ModelInfo> {
  bool dialogues = true;

  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('user');

  String submissionDate = '';
  String firstname = '';

  @override
  void initState() {
    super.initState();

    checkUser();
  }

  checkUser() async {
    final data = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();

    setState(() {
      submissionDate = data['prof_submitting_time'];
      firstname = data['first_name'];
      if (data['verification'] == 'submitted') {
        dialogues = false;
      } else {
        dialogues = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text(
          'Info',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          dialogues
              ? Container(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 14, right: 14),
                              child: Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.6,

                                margin: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 8),
                                //padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).indicatorColor,
                                      width: 0.5),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  boxShadow: <BoxShadow>[
                                    new BoxShadow(
                                      color: Theme.of(context)
                                          .indicatorColor
                                          .withAlpha(100),
                                      blurRadius: 16.0,
                                      offset: new Offset(0.0, 3.0),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Text(
                                          'Hi $firstname,',
                                          style: TextStyle(
                                            fontSize: 22,
                                            // color: Constants.maincolor
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 16),
                                        child: Text(
                                          'Welcome to TRUTHIN-X, Before you can book models, We will need a few more things so we can verify your profile. ',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      CupertinoButton(
                                          child: Text(
                                            'Complete Final Steps',
                                            // style: TextStyle(color: Constants.maincolor),
                                          ),
                                          color: Constants.maincolor,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ModelVerification1()),
                                            );
                                          }),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 0.0, left: 5, right: 5),
                        child: Container(
                          width: double.infinity,
                          // height: MediaQuery.of(context).size.height * 0.6,

                          margin:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                          //padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Aplication in Review',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.orange[200]),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 16),
                                  child: Text(
                                    'Your account is in review we will let you know in 2 days that your account has been approved, so stay tight',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                        letterSpacing: 0.3),
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 16),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Submission Date: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                            letterSpacing: 0.3),
                                        // textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '$submissionDate',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.orange[200],
                                            letterSpacing: 0.3),
                                        // textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
