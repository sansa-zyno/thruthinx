import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Change Password",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
                ),
                Divider(),
                SizedBox(height: 20),
                TextField(
                  controller: oldPassword,
                  enabled: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16),
                    labelText: "Old Password",
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(300.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: newPassword,
                  enabled: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16),
                    labelText: "New Password",
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(300.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: confirmNewPassword,
                  enabled: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16),
                    labelText: "Confirm New Password",
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(300.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      if (loading) {
                        return;
                      }
                      setState(() {
                        loading = true;
                      });
                      updatePassword();
                    },
                    icon: loading
                        ? Transform.scale(
                            scale: 0.5,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.black),
                            ),
                          )
                        : Icon(Icons.vpn_key_rounded),
                    label: Text("Update")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updatePassword() async {
    if (newPassword.text.trim() != confirmNewPassword.text.trim()) {
      Fluttertoast.showToast(
          msg: "New Password and Confirm Password does not match");
      setState(() {
        loading = false;
      });
      return;
    }
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    // Create a credential
    AuthCredential credential = EmailAuthProvider.credential(
        email: "hassamtalha123@gmail.com", password: "123456");
    try {
// Reauthenticate
      UserCredential cred = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      print(cred.user!.email);

      user!
          .updatePassword(newPassword.text.trim())
          .onError((error, stackTrace) {
        print(error.toString());
        setState(() {
          loading = false;
        });
      }).then((value) {
        Fluttertoast.showToast(msg: "Password Changed Successfully!");
        Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
