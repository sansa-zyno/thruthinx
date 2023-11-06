/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/screens/Profile/AccountSettings/edit_instagram.dart';
import 'package:truthinx/screens/Startup_screens/welcome.dart';

import '../../Profile/AccountSettings/deactivate_account.dart';

class ProfileCustomer extends StatefulWidget {
  ProfileCustomer({Key? key}) : super(key: key);

  @override
  _ProfileCustomerState createState() => _ProfileCustomerState();
}

class _ProfileCustomerState extends State<ProfileCustomer> {
  bool _lights = false;

  Future<void> _signOut() async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Welcome()),
            ));
  }

  messageAllert(String msg, String ttl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(ttl),
            ),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Column(
                    children: <Widget>[
                      Text('yes'),
                    ],
                  ),
                  onPressed: _signOut),
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Column(
                  children: <Widget>[
                    Text('No'),
                  ],
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          );
        });
  }

  Future<bool> _onLogoutPressed() {
    return messageAllert('You want to logout ', 'Are you sure?');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text(
          'Account Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: 32,
            color: Colors.grey[800],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Account',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 14.0, right: 14.0, top: 10, bottom: 4),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Allow Notifications',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white70,
                        letterSpacing: 0.3),
                  ),
                  CupertinoSwitch(
                    value: _lights,
                    onChanged: (bool value) {
                      setState(() {
                        _lights = value;
                      });
                    },
                  ),
                ]),
          ),
          Divider(
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditInstagram()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14.0, top: 10, bottom: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Instagram',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white70,
                          letterSpacing: 0.3),
                    ),
                    Text(
                      '@john323',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white38,
                          letterSpacing: 0.3),
                    ),
                  ]),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14.0, top: 10, bottom: 4),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white70,
                          letterSpacing: 0.3),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                    )
                  ]),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14.0, top: 10, bottom: 4),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Categories',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white70,
                          letterSpacing: 0.3),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                    )
                  ]),
            ),
          ),
          Divider(
            color: Colors.transparent,
          ),
          Container(
            height: 32,
            color: Colors.grey[800],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Other Stuff',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: _onLogoutPressed,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14.0, top: 14, bottom: 10),
              child: Text(
                'Logout',
                style: TextStyle(
                    fontSize: 17, color: Colors.white70, letterSpacing: 0.3),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14.0, top: 10, bottom: 10),
              child: Text(
                'Rate us in playstore',
                style: TextStyle(
                    fontSize: 17, color: Colors.white70, letterSpacing: 0.3),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              messageAllert(
                  'Send an email to reset your password at john@gmail.com ',
                  'Are you sure?');
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14.0, top: 10, bottom: 10),
              child: Text(
                'Reset Password',
                style: TextStyle(
                    fontSize: 17, color: Colors.white70, letterSpacing: 0.3),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14.0, top: 10, bottom: 10),
              child: Text(
                'App version 1.0',
                style: TextStyle(
                    fontSize: 17, color: Colors.white70, letterSpacing: 0.3),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeactivateAccount()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14.0, top: 10, bottom: 10),
              child: Text(
                'Deactivate Account',
                style: TextStyle(
                    fontSize: 17, color: Colors.white70, letterSpacing: 0.3),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}*/
