import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truthinx/screens/Dashboard/main_screen_customer.dart';
import 'package:truthinx/screens/Dashboard/main_screen_model.dart';
import 'package:truthinx/Services/ProfileServices.dart';

import 'package:truthinx/Models/AppUser.dart';

class EditInstagram extends StatefulWidget {
  final String? instagram;
  EditInstagram({Key? key, this.instagram}) : super(key: key);

  @override
  _EditInstagramState createState() => _EditInstagramState();
}

class _EditInstagramState extends State<EditInstagram> {
  TextEditingController instaController = TextEditingController();
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
    instaController.dispose();
  }

  ProfileServices profileData = ProfileServices();
  AppUser? appUser;
  @override
  void initState() {
    super.initState();
    profileData.getLocalUser().then((value) {
      setState(() {
        appUser = value;
        print(appUser!.instagram);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text(
          'Edit Instagram',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .015),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: instaController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.instagram == "default"
                          ? "@example"
                          : widget.instagram,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.grey[400])),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                changeInstaAccount();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(143, 148, 251, 1),
                      Color.fromRGBO(143, 148, 251, .6),
                    ])),
                child: Center(
                  child: loading
                      ? CircularProgressIndicator()
                      : Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeInstaAccount() async {
    if (instaController.text.isEmpty || !instaController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Please enter a valid account");
      return;
    }
    setState(() {
      loading = true;
    });
    User? user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .update({"instagram": instaController.text.trim()}).then((value) async {
      Fluttertoast.showToast(msg: "Successfully Updated");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> data = prefs.getStringList('userData') ?? [];
      data[6] = instaController.text.trim();
      prefs.setStringList("userData", data);
      setState(() {
        loading = false;
      });

      if (appUser!.role == "Client") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreenCustomer()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreenModel()),
            (route) => false);
      }
    });
  }
}
