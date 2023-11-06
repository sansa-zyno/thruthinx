import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/screens/Widgets/GetVerifiedContainer.dart';
import 'package:truthinx/screens/Widgets/WaitForVerificationWidget.dart';
import 'package:truthinx/utils/constants.dart';

class ClientInfo extends StatefulWidget {
  ClientInfo({Key? key}) : super(key: key);

  @override
  _ClientInfoState createState() => _ClientInfoState();
}

class _ClientInfoState extends State<ClientInfo> {
  bool dialogues = true;

  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('user');
  String status = "";
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
      firstname = data['first_name'];
      if (data['verification'] == 'submitted') {
        dialogues = false;
        status = "Submitted";
      } else if (data['verification'] == 'VERIFIED') {
        dialogues = false;
        status = "Verified";
      } else {
        dialogues = true;
        status = "Incomplete";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text(
          'Account Status',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          dialogues
              ? GetVerifiedWidget(
                  firstname: firstname,
                  role: "Client",
                )
              : status == "Verified"
                  ? VerifiedContainer(firstname)
                  : WaitForVerificationWidget()
        ],
      ),
    );
  }
}

class VerifiedContainer extends StatelessWidget {
  final String name;

  VerifiedContainer(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.6,

                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    //padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).indicatorColor, width: 0.5),
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color:
                              Theme.of(context).indicatorColor.withAlpha(100),
                          blurRadius: 16.0,
                          offset: new Offset(0.0, 3.0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Hi $name,',
                              style: TextStyle(
                                fontSize: 22,
                                // color: Constants.maincolor
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Icon(
                            Icons.verified_user,
                            color: Constants.maincolor,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 16),
                            child: Text(
                              '''Welcome to TRUTHIN-X, your account is verified. You can use all the features without any ristrictions.
\nPlease make sure to read terms & Policies. In case of violation your account may be suspended''',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          CupertinoButton(
                              child: Text(
                                'Verified',
                                // style: TextStyle(color: Constants.maincolor),
                              ),
                              color: Constants.maincolor,
                              onPressed: () {}),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
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
