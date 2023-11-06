import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:truthinx/screens/stripe/stripe_payment.dart';
import 'package:truthinx/screens/stripe/stripe_server.dart';

class Subscriptions extends StatefulWidget {
  @override
  _SubscriptionsState createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSubscribed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Subscriptions"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Color(0xFF23242A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFF3F8CFC),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: Center(
                          child: Text(
                        "RECOMMENDED BY EXPERTS",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            fontFamily:
                                GoogleFonts.nunito(fontWeight: FontWeight.w500)
                                    .fontFamily),
                      )),
                    ),
                    Visibility(
                      visible: !isSubscribed,
                      child: Column(
                        children: [
                          Text(
                            "Pro",
                            style: TextStyle(
                                fontSize: 34,
                                fontFamily: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold)
                                    .fontFamily),
                          ),
                          Text(
                            "Advanced Features",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontFamily: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold)
                                    .fontFamily),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "\$90.00",
                            style: TextStyle(
                                fontSize: 34,
                                fontFamily: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold)
                                    .fontFamily),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "/per Annum",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontFamily: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold)
                                    .fontFamily),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: isSubscribed,
                      child: Lottie.network(
                          "https://assets1.lottiefiles.com/temp/lf20_305n7k.json",
                          height: 170),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: Color(0xFF273952),
                          child: Icon(Icons.check, color: Color(0xFF3F8CFC)),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Access to all features",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold)
                                  .fontFamily),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: Color(0xFF273952),
                          child: Icon(Icons.check, color: Color(0xFF3F8CFC)),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Better reach",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold)
                                  .fontFamily),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: Color(0xFF273952),
                          child: Icon(Icons.check, color: Color(0xFF3F8CFC)),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Priotity support",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold)
                                  .fontFamily),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: Color(0xFF273952),
                          child: Icon(Icons.check, color: Color(0xFF3F8CFC)),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "No Payment Fee",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold)
                                  .fontFamily),
                        ),
                      ],
                    ),
                    FutureBuilder(
                      future: checkForSubscription(),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.hasData) {
                          if (isSubscribed) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              70,
                                      vertical: 5)),
                              onPressed: null,
                              child: Text("Subscribed"),
                            );
                          } else {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              70,
                                      vertical: 5)),
                              onPressed: stripe,
                              child: Text("Choose pro"),
                            );
                          }
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    SizedBox(height: 1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkForSubscription() {
    try {
      FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Subscriptions")
          .doc("Yearly")
          .get()
          .then((value) {
        if (value.exists) {
          if (this.mounted) {
            setState(() {
              isSubscribed = true;
            });
          }
        }
      });
      return Future.value(isSubscribed);
    } catch (e) {
      print(e);
      return Future.value(isSubscribed);
    }
  }

  void stripe() async {
    final sessionId = await StripeServer(
            userId: FirebaseAuth.instance.currentUser!.uid, price: 9000)
        .createCheckout();

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StripePaymentCheckout(
          sessionId: sessionId,
        ),
      ),
    );
    SnackBar snackbar;
    if (result == "success") {
      snackbar = SnackBar(
        content: Text("Payment Successful!"),
      );
      FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Subscriptions")
          .doc("Yearly")
          .set({
        'subscriptionDate': Timestamp.now(),
      });
      setState(() {
        isSubscribed = true;
      });
    } else {
      snackbar = SnackBar(
        content: Text("Payment Canceled"),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
