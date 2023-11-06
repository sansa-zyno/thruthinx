import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/screens/Dashboard/ClientVerification/verfication_client1.dart';
import 'package:truthinx/screens/ModelVerificationScreens/screen1.dart';
import 'package:truthinx/utils/constants.dart';

class GetVerifiedWidget extends StatelessWidget {
  final String firstname;
  final String role;

  GetVerifiedWidget({required this.firstname, required this.role});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.6,

                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    //padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).indicatorColor, width: 0.5),
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color:
                              Theme.of(context).indicatorColor.withAlpha(100),
                          blurRadius: 16.0,
                          offset: new Offset(0.0, 3.0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Hi $firstname,',
                              style: TextStyle(
                                fontSize: 22,
                                // color: Constants.maincolor
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 16),
                            child: Text(
                              role == "Client"
                                  ? 'Welcome to TRUTHIN-X, Before you can book models, We will need a few more things so we can verify your profile. '
                                  : "Welcome to TRUTHIN-X, Before you can see Gigs from top Clients and Apply to them, you need to verify your account.",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          CupertinoButton(
                              child: Text(
                                'Complete Final Steps',
                                // style: TextStyle(color: Constants.maincolor),
                              ),
                              color: Constants.maincolor,
                              onPressed: () {
                                if (role == "Client") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ClientVerification1()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Screen1()),
                                  );
                                }
                              }),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
