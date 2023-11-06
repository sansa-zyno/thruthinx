import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:truthinx/screens/Profile/AccountSettings/change_password.dart';
import 'package:truthinx/screens/Profile/AccountSettings/deactivate_account.dart';
import 'package:truthinx/screens/Profile/AccountSettings/edit_instagram.dart';
import 'package:truthinx/Models/AppUser.dart';
import 'package:truthinx/screens/Profile/AccountSettings/edit_profile.dart';
import 'package:truthinx/screens/Startup_screens/welcome.dart';

class AccountSettings extends StatefulWidget {
  final AppUser userData;
  AccountSettings(this.userData);
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  bool notificationStatus = false;
  bool extendedFloat = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (!extendedFloat) {
            setState(() {
              extendedFloat = true;
            });
          } else {
            logoutUser();
          }
        },
        label: Text("Logout"),
        icon: Icon(Icons.logout),
        isExtended: extendedFloat,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Settings",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 6),
                Image.asset("assets/user.png", color: Colors.white, height: 24),
                SizedBox(width: 10),
                Text(
                  "Account",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfile(widget.userData)));
              },
              enabled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              leading: Text(
                "Edit Profile",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              },
              enabled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              leading: Text(
                "Change Password",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditInstagram(instagram: widget.userData.instagram),
                  ),
                );
              },
              enabled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              leading: Text(
                "Instagram",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              trailing: Text(widget.userData.instagram == "default"
                  ? "Add account"
                  : widget.userData.instagram!),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 6),
                Image.asset("assets/notification.png",
                    color: Colors.white, height: 24),
                SizedBox(width: 10),
                Text(
                  "Notifications",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            Divider(),
            FutureBuilder(
                future: getNotificationStatus(),
                builder: (context, AsyncSnapshot<bool> snap) {
                  if (snap.hasData) {
                    return SwitchListTile(
                      value: notificationStatus,
                      onChanged: (v) {
                        setState(() {
                          notificationStatus = v;
                          changeNotificationStatus(v);
                        });
                      },
                      title: Text(
                        "App Notifications",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    );
                  } else {
                    return Container();
                  }
                }),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 6),
                Image.asset("assets/ellipsis.png",
                    //color: Colors.white,
                    height: 24),
                SizedBox(width: 10),
                Text(
                  "More",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DeactivateAccount(userData: widget.userData),
                    ));
                // Fluttertoast.showToast(
                //     msg: "Implemented. But temporarily disabled");
              },
              enabled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              leading: Text(
                "Deactivate Account",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              leading: Text(
                "App Version",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              trailing: Text("1.0.1"),
            ),
          ],
        ),
      ),
    );
  }

  void logoutUser() async {
    await FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Welcome()),
            (route) => false));
  }

  Future<bool> getNotificationStatus() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("notifications")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      var b = doc.data() as Map<String, dynamic>;
      notificationStatus = b["allowed"];
    });
    return doc["allowed"];
  }

  changeNotificationStatus(bool value) {
    FirebaseFirestore.instance
        .collection("notifications")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "allowed": value,
    });
  }
}
