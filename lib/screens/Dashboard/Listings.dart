import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:truthinx/Models/Gig.dart';
import 'package:truthinx/screens/Dashboard/MyGigs/ModelGigCard.dart';

import 'package:truthinx/screens/Widgets/GetVerifiedContainer.dart';
import 'package:truthinx/screens/Widgets/WaitForVerificationWidget.dart';

class Listings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listings"),
      ),
      body: FutureBuilder(
        future: getUserData(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var data = snapshot.data;
            if (data!['verification'] == 'submitted') {
              return WaitForVerificationWidget();
            } else if (data!['verification'] == 'VERIFIED') {
              return StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Gigs").snapshots(),
                // initialData: initialData,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    int allDocs = snapshot.data!.docs.length;
                    List<DocumentSnapshot> docs = snapshot.data!.docs;
                    return PageView(
                      children: List.generate(allDocs, (index) {
                        return ModelGigCard(
                          gig: Gig.fromMap(
                              docs[index].data() as Map<String, dynamic>),
                          proposalIndex: index + 1,
                          totalProposals: allDocs,
                          docId: docs[index].id,
                        );
                      }),
                    );
                  } else {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(),
                          Lottie.asset("assets/notFound.json"),
                          Text("No Gigs found!")
                        ],
                      );
                    }
                  }
                },
              );
            } else {
              return GetVerifiedWidget(
                firstname: data!['first_name'],
                role: "Model",
              );
            }
          } else {
            return Center(
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot> getUserData() async {
    return FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }
}
