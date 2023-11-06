import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:truthinx/Models/Proposal.dart';
import 'package:truthinx/screens/Dashboard/MyProposals/ProposalCard.dart';

class ClientProposals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Proposals"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("MyProposals")
            .snapshots(),
        // initialData: initialData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            int allDocs = snapshot.data!.docs.length;

            List<DocumentSnapshot> docs = snapshot.data!.docs;

            return PageView(
              children: List.generate(allDocs, (index) {
                return ProposalCard(
                  proposal: ClientProposal.fromMap(
                      docs[index].data() as Map<String, dynamic>),
                  proposalIndex: index + 1,
                  totalProposals: allDocs,
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
                  Text("No Proposals found!")
                ],
              );
            }
          }
        },
      ),
    );
  }
}
