import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:truthinx/Services/ProfileServices.dart';
import 'package:truthinx/Models/AppUser.dart';
import 'package:truthinx/Models/Gig.dart';

class CreateGig extends StatefulWidget {
  @override
  _CreateGigState createState() => _CreateGigState();
}

class _CreateGigState extends State<CreateGig> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextEditingController title = TextEditingController();

  TextEditingController role = TextEditingController();

  TextEditingController desc = TextEditingController();

  TextEditingController requirements = TextEditingController();
  TextEditingController hourlyrate = TextEditingController();
  AppUser? user;
  ProfileServices profileData = ProfileServices();
  void initState() {
    super.initState();
    profileData.getLocalUser().then((value) {
      setState(() {
        user = value;
        print(user!.verification);
      });
    });
  }

  int _radioValue = 0;
  String gender = "Male";
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          gender = "Male";
          break;
        case 1:
          gender = "Female";
          break;
        default:
          gender = "Male";
          break;
      }
      print(gender);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Gig"),
      ),
      body: user == null
          ? Center(
              // child: ElevatedButton(
              //   onPressed: () {
              //     FirebaseAuth au = FirebaseAuth.instance;
              //     au.signOut();
              //     Navigator.pushAndRemoveUntil(
              //         context,
              //         MaterialPageRoute(builder: (context) => Welcome()),
              //         (route) => false);
              //   },
              //   child: Text("Logiout"),
              // ),
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: TextField(
                          controller: title,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Job Title"),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: TextField(
                          controller: role,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Role"),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Container(
                        height: 200,
                        child: TextField(
                          controller: desc,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 8,
                          maxLength: 500,
                          minLines: 1,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Job Description"),
                        ),
                      ),
                    ),
                  ),
                  Card(
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
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Container(
                        height: 200,
                        child: TextField(
                          controller: requirements,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 8,
                          maxLength: 500,
                          minLines: 1,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Requirements"),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Male"),
                      Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: null //_handleRadioValueChange,
                          ),
                      Text("Female"),
                      Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: null //_handleRadioValueChange,
                          ),
                    ],
                  ),
                  SizedBox(height: 20),
                  RoundedLoadingButton(
                    controller: _btnController,
                    onPressed: () {
                      createGig();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 90),
                      child: Text(
                        "    Create    ",
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 70),
                ],
              ),
            ),
    );
  }

  createGig() async {
    if (title.text.isEmpty ||
        role.text.isEmpty ||
        hourlyrate.text.isEmpty ||
        desc.text.isEmpty ||
        requirements.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter all the details");
      _btnController.reset();
      return;
    }

    try {
      String userDp = await getUserDp();
      Gig gig = Gig(
          clientID: FirebaseAuth.instance.currentUser!.uid,
          dateCreated: Timestamp.now(),
          gigOrder: DateTime.now().millisecondsSinceEpoch,
          clientDp: userDp,
          clientName: "${user!.first_name} ${user!.last_name}",
          title: title.text,
          role: role.text,
          hourlyRate: hourlyrate.text.trim(),
          requirements: requirements.text,
          gender: gender,
          desc: desc.text);

      await FirebaseFirestore.instance
          .collection("Gigs")
          .doc()
          .set(gig.toMap());

      _btnController.success();
      Fluttertoast.showToast(msg: "Successfully created gig!");
      Timer(Duration(seconds: 2), () {
        _btnController.reset();
        Navigator.pop(context);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      _btnController.error();
      Timer(Duration(seconds: 2), () {
        _btnController.reset();
      });
    }
  }

  Future<String> getUserDp() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return doc["dp"];
  }
}
