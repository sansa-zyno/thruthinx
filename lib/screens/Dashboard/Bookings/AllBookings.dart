import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:truthinx/screens/Dashboard/Bookings/BookingCard.dart';
import 'package:truthinx/screens/Dashboard/Bookings/BookingModel.dart';

class AllBookings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Bookings"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Bookings")
            .snapshots(),
        // initialData: initialData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            int allDocs = snapshot.data!.docs.length;
            List<DocumentSnapshot> docs = snapshot.data!.docs;
            return PageView(
              children: List.generate(allDocs, (index) {
                return BookingCard(
                  bm: BookingModal.fromMap(
                      docs[index].data() as Map<String, dynamic>),
                  bookingIndex: index + 1,
                  docId: docs[index].id,
                  totalBookings: allDocs,
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
                  Text("No Bookings found!")
                ],
              );
            }
          }
        },
      ),
    );
  }
}
