import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:truthinx/screens/Dashboard/add_card.dart';
import 'package:truthinx/utils/constants.dart';

class PaymentsModel extends StatefulWidget {
  PaymentsModel({Key? key}) : super(key: key);

  @override
  _PaymentsModelState createState() => _PaymentsModelState();
}

class _PaymentsModelState extends State<PaymentsModel> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text(
          'Payments',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCard()),
                );
              })
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, left: 5, right: 5),
                    child: Container(
                      width: double.infinity,
                      // height: MediaQuery.of(context).size.height * 0.6,

                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      //padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).indicatorColor,
                            width: 0.5),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Add card for payments',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.orange[200]),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 16),
                              child: Text(
                                'In order for you to automatically recieve cashless instant payments for jobs booked on Truthin-x you must connect your bank account through a debit card',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                    letterSpacing: 0.3),
                                // textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 16),
                              child: CupertinoButton(
                                  child: Text(
                                    'Add Debit Card',
                                    // style: TextStyle(color: Constants.maincolor),
                                  ),
                                  color: Constants.maincolor,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddCard()),
                                    );
                                  }),
                            ),
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
      ),
    );
  }
}
