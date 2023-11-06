import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/Services/NotificationServices.dart';
import 'package:truthinx/Services/ProfileServices.dart';

import 'package:truthinx/Models/AppUser.dart';
import 'package:truthinx/screens/Dashboard/bottomTabs/Drawer.dart';
import 'package:truthinx/screens/Dashboard/bottomTabs/ModelDrawer.dart';
import 'package:truthinx/screens/Dashboard/search.dart';
import 'package:truthinx/screens/Widgets/Model_Grid_Item.dart';

class HomeScreenCustomer extends StatefulWidget {
  HomeScreenCustomer({Key? key}) : super(key: key);

  @override
  _HomeScreenCustomerState createState() => _HomeScreenCustomerState();
}

const double width = 330.0;
const double height = 35.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Colors.grey;

CollectionReference collectionReferenceUser =
    FirebaseFirestore.instance.collection('user');

class _HomeScreenCustomerState extends State<HomeScreenCustomer> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<bool> _saveTokenToDatabase() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String? fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokenRef =
          FirebaseFirestore.instance.collection("notifications").doc(uid);

      await tokenRef.update(
        {"fcmToken": fcmToken, "createdAt": FieldValue.serverTimestamp()},
      );
    }
    return Future.value(true);
  }

  ProfileServices profileData = ProfileServices();
  AppUser? user;

  @override
  void initState() {
    super.initState();
    //  profileData.getLocalUser().then((value) {
    //   setState(() {
    //     user = value;
    //     print(user.instagram);
    //   });
    // });
    _saveTokenToDatabase();
    /* _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );*/
  }

  bool isClient = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.black12,
          centerTitle: true,
          title: Text(
            'Models',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, size: 30),
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return Search(isClient: isClient);
                    }));
              },
            )
          ],
        ),
        drawer: FutureBuilder(
            future: profileData.getLocalUser(),
            builder: (context, AsyncSnapshot<AppUser> snap) {
              if (snap.hasData) {
                isClient = snap.data!.role == "Client";
                if (snap.data!.role == "Client") {
                  return TruthinXDrawer();
                } else {
                  return ModelDrawer();
                }
              } else {
                return Container();
              }
            }),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: collectionReferenceUser
                    // .where("verification", isEqualTo: 'submitted')
                    .where("role", isEqualTo: 'Model')
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: ScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.4),
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data = snapshot.data!.docs[index];
                            return GridProduct(
                              // img: data['profile_pic'],
                              isVerified: data['verification'] == "VERIFIED",
                              name: data['first_name'],
                              rating: 5.0,
                              raters: 23,
                              gender: data["gender"],
                              img: data["dp"],
                              details: data,
                              isClient: isClient,
                            );
                          },
                        );
                },
              ),
            ),
//             Expanded(
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 primary: false,
//                 physics: ScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: MediaQuery.of(context).size.width /
//                       (MediaQuery.of(context).size.height / 1.4),
//                 ),
//                 itemCount: foods == null ? 0 : foods.length,
//                 itemBuilder: (BuildContext context, int index) {
// //                Food food = Food.fromJson(foods[index]);
//                   Map food = foods[index];
// //                print(foods);
// //                print(foods.length);
//                   return GridProduct(
//                     img: food['img'],
//                     isFav: false,
//                     name: food['name'],
//                     rating: 5.0,
//                     raters: 23,
//                   );
//                 },
//               ),
//             ),
          ],
        ));
  }
}
