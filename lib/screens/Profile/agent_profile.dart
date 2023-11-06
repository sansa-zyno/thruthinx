import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:truthinx/Services/ProfileServices.dart';
import 'package:truthinx/Models/AppUser.dart';
import 'package:truthinx/screens/Dashboard/bottomTabs/client_info.dart';
import 'package:truthinx/screens/ModelVerificationScreens/screen1.dart';
import 'package:truthinx/screens/Profile/AccountSettings/account_settings.dart';
import 'package:truthinx/screens/Profile/Instagram/InstagramProfile.dart';
import 'package:truthinx/screens/Widgets/Profile_Widgets/CategoryChip.dart';

class AgentProfile extends StatefulWidget {
  @override
  _AgentProfileState createState() => _AgentProfileState();
}

class _AgentProfileState extends State<AgentProfile> {
  ProfileServices profileData = ProfileServices();
  AppUser? user;
  @override
  void initState() {
    super.initState();
    profileData.getLocalUser().then((value) {
      setState(() {
        user = value;
        print(user!.instagram);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Profile"),
          actions: [
            IconButton(
              icon: Image.asset(
                "assets/settings.png",
                color: Colors.white,
                height: 24,
              ),
              onPressed: () {
                if (user != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountSettings(user!)));
                }
              },
            )
          ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AvatarGlow(
                            glowColor: Colors.teal,
                            endRadius: 55.0,
                            duration: Duration(milliseconds: 2000),
                            repeat: true,
                            animate: true,
                            showTwoGlows: true,
                            repeatPauseDuration: Duration(milliseconds: 100),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 45,
                              backgroundImage: AssetImage("assets/dp.JPG"),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user!.first_name} ${user!.last_name}",
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(user!.role!)
                          ],
                        )
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 20),
                    TextField(
                      enabled: false,
                      controller: TextEditingController()..text = user!.email!,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 16),
                        labelText: "Email",
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(300.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(300)),
                      child: ListTile(
                        onTap: () {
                          if (user!.instagram == "default") {
                            Fluttertoast.showToast(
                                msg: "Please Attach an account from settings!",
                                toastLength: Toast.LENGTH_LONG);
                            return;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InstagramProfile("${user!.instagram}")
                                  //INsta()
                                  ));
                        },
                        subtitle: Text(
                          user!.instagram == "default"
                              ? "No Account attached"
                              : user!.instagram!,
                        ),
                        leading: Image.asset(
                          "assets/instagram.png",
                          height: 32,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                        title: Text("Instagram"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16),
                      child: Row(
                        children: [
                          Text(
                            "Bio    ",
                            style: TextStyle(fontSize: 16),
                          ),
                          Expanded(
                            child: Divider(),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                        future: profileData.getUserCategories(),
                        builder:
                            (context, AsyncSnapshot<List<String>> snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            print(snapshot.data);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Categories :"),
                                ),
                                Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: snapshot.data!.map((cat) {
                                      return CategoryChip(cat.split("***")[0]);
                                    }).toList()),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                    SizedBox(
                      height: 60,
                    ),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("user")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData && snapshot.data!.exists) {
                            DocumentSnapshot doc = snapshot.data!;
                            if (doc['verification'] == "UNKNOWN") {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton.icon(
                                    icon: Icon(Icons.account_circle),
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(300))),
                                    onPressed: () {
                                      if (user!.role == "Client") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ClientInfo()));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Screen1()));
                                      }
                                    },
                                    label: Text("Complete Profile")),
                              );
                            } else {
                              if (doc['verification'] == "submitted") {
                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ElevatedButton.icon(
                                      icon: Icon(Icons.account_circle),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(300))),
                                      onPressed: null,
                                      label:
                                          Text("Profile Verification Pending")),
                                );
                              } else {
                                return Container();
                              }
                            }
                          } else {
                            return Container();
                          }
                        })
                  ],
                ),
              ));
  }
}
