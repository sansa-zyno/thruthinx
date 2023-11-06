import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:truthinx/screens/Dashboard/main_screen_model.dart';
import 'package:truthinx/Models/modelDataModel.dart';
import 'package:truthinx/Services/ProfileServices.dart';
import 'package:truthinx/Models/AppUser.dart';
import 'package:truthinx/utils/constants.dart';

class Screen7 extends StatefulWidget {
  ModelDataModel modelData;
  Screen7(this.modelData);

  @override
  _Screen7State createState() => _Screen7State();
}

class _Screen7State extends State<Screen7> {
  String nudityStatus = '';
  String uuid = '';
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  ProfileServices profileData = ProfileServices();
  AppUser? user;

  @override
  void initState() {
    super.initState();
    getLocalUser();
  }

  getLocalUser() async {
    uuid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nudity"),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Interested in jobs requiring nudity? ",
                        textScaleFactor: 1.4,
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                    CategoryItem(
                        categoryName: "None",
                        nudityStatus: nudityStatus,
                        setNudity: setNudityStatus),
                    CategoryItem(
                        categoryName: "Partial",
                        nudityStatus: nudityStatus,
                        setNudity: setNudityStatus),
                    CategoryItem(
                        categoryName: "Full",
                        nudityStatus: nudityStatus,
                        setNudity: setNudityStatus),

                    // CategoryItem(categoryName: ""),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.black,
                height: 70,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 5),
                    //   child: Text(
                    //     "Select 1 or more personality attributes that best describe you",
                    //     textScaleFactor: 1.4,
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    RoundedLoadingButton(
                      controller: _btnController,
                      onPressed: () {
                        if (nudityStatus == null || nudityStatus.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please select Nudity Status!');
                        } else {
                          widget.modelData.nudityStatus = nudityStatus;
                          sendProfileDataToVerify();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           Screen8(widget.modelData)),
                          // );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 70),
                        child: Text(
                          "Save",
                          textScaleFactor: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  setNudityStatus(value) {
    setState(() {
      nudityStatus = value;
    });
    print("Nudity cahnged to $value");
  }

  void sendProfileDataToVerify() async {
    String headshotURL = await uploadImageToFirebase(widget.modelData.dp!);
    widget.modelData.dp = headshotURL;
    List<String> bestPhotosURLs = [];
    for (int i = 0; i < 5; i++) {
      bestPhotosURLs
          .add(await uploadImageToFirebase(widget.modelData.bestPhotos![i]));
    }
    print("+++++++++++++++");
    print(bestPhotosURLs);
    widget.modelData.bestPhotos = bestPhotosURLs;
    widget.modelData.verification = "PENDING";
    FirebaseFirestore.instance
        .collection("user")
        .doc(uuid)
        .update(widget.modelData.toMap())
        .onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
      _btnController.error();
    }).whenComplete(() {
      FirebaseFirestore.instance
          .collection("Verifications")
          .doc(uuid)
          .set({"ref": uuid});
      Fluttertoast.showToast(
          msg:
              "Your Application has been submitted and will be verified by the admin! Stay tuned, you will be notified.",
          toastLength: Toast.LENGTH_LONG);
      _btnController.success();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreenModel()));
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "Something went wrong! Please try again later.",
          toastLength: Toast.LENGTH_LONG);
      _btnController.error();
      Timer(Duration(seconds: 2), () {
        _btnController.reset();
      });
    });
  }

  Future<String> uploadImageToFirebase(String _imageFile) async {
    String downloadUrl = '';
    String fileName = getRandomString(10);
    File imageFile = File(_imageFile);

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    TaskSnapshot uploadTask = await firebaseStorageRef.putFile(imageFile);
    downloadUrl = await uploadTask.ref.getDownloadURL();

    return downloadUrl;
  }
}

class CategoryItem extends StatefulWidget {
  final String categoryName;
  final String nudityStatus;
  final Function setNudity;
  const CategoryItem(
      {required this.categoryName,
      required this.nudityStatus,
      required this.setNudity});
  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool isMark = false;

  @override
  Widget build(BuildContext context) {
    print("${widget.categoryName} --- ${widget.nudityStatus}");

    if (widget.categoryName == widget.nudityStatus) {
      isMark = true;
    } else {
      isMark = false;
    }
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isMark = !isMark;
              });
              widget.setNudity(widget.categoryName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0.3, color: Colors.white60),
                  bottom: BorderSide(width: 0.3, color: Colors.white60),
                ),
                // color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.categoryName,
                    textScaleFactor: 1.5,
                    style: TextStyle(
                        fontWeight: isMark ? FontWeight.w600 : FontWeight.w300),
                  ),
                  if (isMark)
                    Icon(
                      Icons.check_rounded,
                      color: Colors.orange,
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
