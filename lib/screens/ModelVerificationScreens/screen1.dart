import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/screens/ModelVerificationScreens/screen2.dart';

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  User? user = FirebaseAuth.instance.currentUser;
  bool dialogues = true;

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
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Hi $firstname,",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "You're almost there! Just a few more steps before we can list you onto the Platform. When you're ready, submit your information and we'll review your application for acception.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey[400]),
            ),
            SizedBox(height: 75),
            ElevatedButton(
              /* shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),*/
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Screen2()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Complete Final Steps",
                  textScaleFactor: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
