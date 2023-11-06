import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:truthinx/Models/AppUser.dart';
import 'package:truthinx/screens/Startup_screens/welcome.dart';

class DeactivateAccount extends StatefulWidget {
  final AppUser? userData;
  DeactivateAccount({Key? key, this.userData}) : super(key: key);

  @override
  _DeactivateAccountState createState() => _DeactivateAccountState();
}

class _DeactivateAccountState extends State<DeactivateAccount> {
  bool _lights = false;
  bool val1 = false;
  bool val2 = false;
  bool val3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text(
          'Deactivate Account',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .015),
            Text(
              'We are very sorry to see you go! we understand that for whatever reason, this might not be working out the way you expected.',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Text(
              'By deactivating your account, all public information associated with your profile will be hidden fron view immediately, and if no signin accours within 30 days, your data will be permanently deleted.',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .04),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CupertinoSwitch(
                value: _lights,
                onChanged: (bool value) {
                  setState(() {
                    _lights = value;
                  });
                },
              ),
              SizedBox(
                width: 30,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'I  ${widget.userData!.first_name}, agree to deactivate my\naccount .',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                Text(
                  'Mark the reason below so we\ncan improve.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ]),
            ]),
            SizedBox(height: MediaQuery.of(context).size.height * .06),
            SwitchListTile(
                title: Text(
                  'Not enough opportunities',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                value: val1,
                onChanged: (newVal) {
                  setState(() {
                    val1 = newVal;
                  });
                }),
            Divider(
              color: Colors.grey,
            ),
            SwitchListTile(
                title: Text(
                  'Job quality below my expectations',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                value: val2,
                onChanged: (newVal) {
                  setState(() {
                    val2 = newVal;
                  });
                }),
            Divider(
              color: Colors.grey,
            ),
            SwitchListTile(
                title: Text(
                  'My application was not approved',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                value: val3,
                onChanged: (newVal) {
                  setState(() {
                    val3 = newVal;
                  });
                }),
            SizedBox(height: MediaQuery.of(context).size.height * .06),
            GestureDetector(
              onTap: () {
                if (_lights) {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Welcome()),
                      (route) => false);
                } else {
                  Fluttertoast.showToast(
                      msg: "Please mark your will to proceed");
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: _lights
                        ? LinearGradient(
                            colors: [Colors.red[400]!, Colors.red[600]!])
                        : LinearGradient(
                            colors: [Colors.grey[200]!, Colors.grey[600]!])),
                child: Center(
                  child: Text(
                    "Deactivate",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
