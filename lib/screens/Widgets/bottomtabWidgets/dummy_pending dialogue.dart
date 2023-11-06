import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/Models/verification/verification_model1.dart';
import 'package:truthinx/utils/constants.dart';

class PendindDilaogue extends StatefulWidget {
  PendindDilaogue({Key? key}) : super(key: key);

  @override
  _PendindDilaogueState createState() => _PendindDilaogueState();
}

class _PendindDilaogueState extends State<PendindDilaogue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text(
          'Info',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
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
                    color: Theme.of(context).indicatorColor.withAlpha(100),
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
                        'Hi John,',
                        style: TextStyle(
                          fontSize: 22,
                          // color: Constants.maincolor
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16),
                      child: Text(
                        'Welcome to TRUTHIN-X, Before you can book models, We will need a few more things so we can verify your profile. ',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    CupertinoButton(
                        child: Text(
                          'Complete Final Steps',
                          // style: TextStyle(color: Constants.maincolor),
                        ),
                        color: Constants.maincolor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModelVerification1()),
                          );
                        }),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
