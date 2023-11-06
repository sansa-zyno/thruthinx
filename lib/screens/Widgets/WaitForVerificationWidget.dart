import 'package:flutter/material.dart';

class WaitForVerificationWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
                      child: Column(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, left: 5, right: 5),
                            child: Container(
                              width: double.infinity,
                              // height: MediaQuery.of(context).size.height * 0.6,

                              margin: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 8),
                              //padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'Aplication in Review',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.orange[200], ),
                                            
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.005),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 16),
                                      child: Text(
                                        'Your account is in review we will let you know in 2 business days that your account has been approved, so stay tight',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                            letterSpacing: 0.3),
                                        // textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
  }
}