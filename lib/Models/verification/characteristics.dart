import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:truthinx/screens/Dashboard/main_screen_model.dart';
import 'package:truthinx/Models/widgets/base_appbar.dart';

import 'package:truthinx/utils/constants.dart';

class Characteristics extends StatefulWidget {
  Characteristics({Key? key}) : super(key: key);

  @override
  _CharacteristicsState createState() => _CharacteristicsState();
}

class _CharacteristicsState extends State<Characteristics> {
  double _valueHeight = 6;
  double _valueweight = 200;
  double _valuedress = 5;
  double _valueHip = 30;
  double _valueWaist = 5;
  double _valueBust = 30;
  double _valueNeck = 13;
  double _valueJacket = 42;
  double _valueShoe = 10;
  double _valueInseam = 35;
  int _cupzise = -1;
  int _hairColor = -1;
  int _eyeColor = -1;

  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('user');

  messageAllert(String msg, String ttl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(ttl),
            ),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Column(
                  children: <Widget>[
                    Text('Cancel'),
                  ],
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Column(
                  children: <Widget>[
                    Text('yes, Continue'),
                  ],
                ),
                onPressed: () => {
                  hitCharacteristics()

                  //  Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MainScreen()),
                  // ),
                },
              ),
            ],
          );
        });
  }

  bool isLoading = false;

  //firebase api call
  void hitCharacteristics() {
    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    collectionReferenceUser.doc(user!.uid).set({
      "gender": Constants.gender ?? '',
      "height": _valueHeight ?? '',
      "weight": _valueweight ?? '',
      "neck": _valueNeck ?? '',
      "jacket": _valueJacket ?? '',
      "dress": _valuedress ?? '',
      "hip": _valueHip ?? '',
      "bust": _valueBust ?? '',
      "waist": _valueWaist ?? '',
      "inseam": _valueInseam ?? '',
      "shoe": _valueShoe ?? '',
      "breast_size": _cupzise ?? '',
      "hair_color": _hairColor ?? '',
      "eye_color": _eyeColor ?? '',
    }, SetOptions(merge: true)).then((res) {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreenModel(index: 1)),
      );
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Oops"),
              content: Text(err.message),
              actions: [
                MaterialButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(
        msg: 'Select all the values carefully and correctly',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER);
  }

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BaseAppBar(
        //cartList: _cartList,
        appBar: AppBar(),
        title: 'Characteristics',
        //onChange: (r) => setState(() => _cartList = r),
      ),
      body: ListView(
        children: [
          SizedBox(height: mQ.height * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ToggleSwitch(
                  minWidth: double.infinity,
                  cornerRadius: 10.0,
                  activeBgColor: [Colors.cyanAccent],
                  activeFgColor: Colors.black87,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  fontSize: 16,
                  labels: ['Female', 'Male', 'Other'],
                  initialLabelIndex: Constants.gender,
                  //     icons: [
                  //  FaIcon(FontAwesomeIcons.facebook),
                  //       Icons.shopping_bag,
                  //       Icons.shopping_bag
                  //     ],
                  onToggle: (index) {
                    print('switched to: $index');
                    setState(() {
                      Constants.gender = index!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: mQ.height * 0.02),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
              child: Text(
                'Do your best to be as accurate as possible and true to yourself!, Setting your measurments allows your profile to be found in search results',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: mQ.height * 0.02),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
              child: Text(
                'Build',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
                //   textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Height: ',
              style: TextStyle(
                  color: Constants.maincolor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.005),
            Text(
              '${_valueHeight.toStringAsFixed(0)}\'${_valueHeight.toString()[2]}"',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3),
            ),
          ]),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Constants.maincolor.withOpacity(0.7),
              inactiveTrackColor: Colors.grey[400]!.withOpacity(0.4),
              trackShape: RoundedRectSliderTrackShape(),
              trackHeight: 2.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              thumbColor: Constants.maincolor,
              overlayColor: Colors.red.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: RoundSliderTickMarkShape(),
              activeTickMarkColor: Constants.maincolor,
              inactiveTickMarkColor: Constants.maincolor.withOpacity(0.1),
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: Constants.maincolor,
              valueIndicatorTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            child: Slider(
              value: _valueHeight,
              min: 5,
              max: 7.5,
              divisions: 1,
              label: _valueHeight.toStringAsFixed(0),
              onChanged: (value) {
                setState(
                  () {
                    _valueHeight = value;
                  },
                );
              },
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Weight: ',
              style: TextStyle(
                  color: Constants.maincolor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.005),
            Text(
              '${_valueweight.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3),
            ),
          ]),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Constants.maincolor.withOpacity(0.7),
              inactiveTrackColor: Colors.grey[400]!.withOpacity(0.4),
              trackShape: RoundedRectSliderTrackShape(),
              trackHeight: 2.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              thumbColor: Constants.maincolor,
              overlayColor: Colors.red.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: RoundSliderTickMarkShape(),
              activeTickMarkColor: Constants.maincolor,
              inactiveTickMarkColor: Constants.maincolor.withOpacity(0.1),
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: Constants.maincolor,
              valueIndicatorTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            child: Slider(
              value: _valueweight,
              min: 100,
              max: 280,
              //   divisions: 140,
              label: _valueweight.toStringAsFixed(0),
              onChanged: (value) {
                setState(
                  () {
                    _valueweight = value;
                  },
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Constants.gender == 0
              ? Container()
              : Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'Neck: ',
                        style: TextStyle(
                            color: Constants.maincolor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.005),
                      Text(
                        '${_valueNeck.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3),
                      ),
                    ]),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Constants.maincolor.withOpacity(0.7),
                        inactiveTrackColor: Colors.grey[400]!.withOpacity(0.4),
                        trackShape: RoundedRectSliderTrackShape(),
                        trackHeight: 2.0,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        thumbColor: Constants.maincolor,
                        overlayColor: Colors.red.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 28.0),
                        tickMarkShape: RoundSliderTickMarkShape(),
                        activeTickMarkColor: Constants.maincolor,
                        inactiveTickMarkColor:
                            Constants.maincolor.withOpacity(0.1),
                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                        valueIndicatorColor: Constants.maincolor,
                        valueIndicatorTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Slider(
                        value: _valueNeck,
                        min: 13,
                        max: 28,
                        // divisions: 140,
                        label: _valueNeck.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(
                            () {
                              _valueNeck = value;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Constants.gender == 0
              ? Container()
              : Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'Jacket: ',
                        style: TextStyle(
                            color: Constants.maincolor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.005),
                      Text(
                        '${_valueJacket.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3),
                      ),
                    ]),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Constants.maincolor.withOpacity(0.7),
                        inactiveTrackColor: Colors.grey[400]!.withOpacity(0.4),
                        trackShape: RoundedRectSliderTrackShape(),
                        trackHeight: 2.0,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        thumbColor: Constants.maincolor,
                        overlayColor: Colors.red.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 28.0),
                        tickMarkShape: RoundSliderTickMarkShape(),
                        activeTickMarkColor: Constants.maincolor,
                        inactiveTickMarkColor:
                            Constants.maincolor.withOpacity(0.1),
                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                        valueIndicatorColor: Constants.maincolor,
                        valueIndicatorTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Slider(
                        value: _valueJacket,
                        min: 36,
                        max: 50,
                        // divisions: 140,
                        label: _valueJacket.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(
                            () {
                              _valueJacket = value;
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ],
                ),
          Constants.gender == 0
              ? Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'Dress: ',
                        style: TextStyle(
                            color: Constants.maincolor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.005),
                      Text(
                        '${_valuedress.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3),
                      ),
                    ]),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Constants.maincolor.withOpacity(0.7),
                        inactiveTrackColor: Colors.grey[400]!.withOpacity(0.4),
                        trackShape: RoundedRectSliderTrackShape(),
                        trackHeight: 2.0,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        thumbColor: Constants.maincolor,
                        overlayColor: Colors.red.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 28.0),
                        tickMarkShape: RoundSliderTickMarkShape(),
                        activeTickMarkColor: Constants.maincolor,
                        inactiveTickMarkColor:
                            Constants.maincolor.withOpacity(0.1),
                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                        valueIndicatorColor: Constants.maincolor,
                        valueIndicatorTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Slider(
                        value: _valuedress,
                        min: 0,
                        max: 12,
                        divisions: 140,
                        label: _valuedress.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(
                            () {
                              _valuedress = value;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Container(),

          //Mid Section
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
              child: Text(
                'Mid Section',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
                //   textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Constants.gender == 1
              ? Container()
              : Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'Hip: ',
                        style: TextStyle(
                            color: Constants.maincolor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.005),
                      Text(
                        '${_valueHip.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3),
                      ),
                    ]),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Constants.maincolor.withOpacity(0.7),
                        inactiveTrackColor: Colors.grey[400]!.withOpacity(0.4),
                        trackShape: RoundedRectSliderTrackShape(),
                        trackHeight: 2.0,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        thumbColor: Constants.maincolor,
                        overlayColor: Colors.red.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 28.0),
                        tickMarkShape: RoundSliderTickMarkShape(),
                        activeTickMarkColor: Constants.maincolor,
                        inactiveTickMarkColor:
                            Constants.maincolor.withOpacity(0.1),
                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                        valueIndicatorColor: Constants.maincolor,
                        valueIndicatorTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Slider(
                        value: _valueHip,
                        min: 25,
                        max: 50,
                        divisions: 140,
                        label: _valueHip.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(
                            () {
                              _valueHip = value;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
          Constants.gender == 1
              ? Container()
              : Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'Bust: ',
                        style: TextStyle(
                            color: Constants.maincolor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.005),
                      Text(
                        '${_valueBust.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3),
                      ),
                    ]),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Constants.maincolor.withOpacity(0.7),
                        inactiveTrackColor: Colors.grey[400]!.withOpacity(0.4),
                        trackShape: RoundedRectSliderTrackShape(),
                        trackHeight: 2.0,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        thumbColor: Constants.maincolor,
                        overlayColor: Colors.red.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 28.0),
                        tickMarkShape: RoundSliderTickMarkShape(),
                        activeTickMarkColor: Constants.maincolor,
                        inactiveTickMarkColor:
                            Constants.maincolor.withOpacity(0.1),
                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                        valueIndicatorColor: Constants.maincolor,
                        valueIndicatorTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Slider(
                        value: _valueBust,
                        min: 27,
                        max: 50,
                        divisions: 140,
                        label: _valueBust.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(
                            () {
                              _valueBust = value;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Waist: ',
              style: TextStyle(
                  color: Constants.maincolor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.005),
            Text(
              '${_valueWaist.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3),
            ),
          ]),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Constants.maincolor.withOpacity(0.7),
              inactiveTrackColor: Colors.grey[400]!.withOpacity(0.4),
              trackShape: RoundedRectSliderTrackShape(),
              trackHeight: 2.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              thumbColor: Constants.maincolor,
              overlayColor: Colors.red.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: RoundSliderTickMarkShape(),
              activeTickMarkColor: Constants.maincolor,
              inactiveTickMarkColor: Constants.maincolor.withOpacity(0.1),
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: Constants.maincolor,
              valueIndicatorTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            child: Slider(
              value: _valueWaist,
              min: 0,
              max: 20,
              divisions: 140,
              label: _valueWaist.toStringAsFixed(0),
              onChanged: (value) {
                setState(
                  () {
                    _valueWaist = value;
                  },
                );
              },
            ),
          ),

          //Mid Section
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
              child: Text(
                'Bottom Section',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
                //   textAlign: TextAlign.center,
              ),
            ),
          ),
          Constants.gender == 0
              ? Container()
              : Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'Inseam: ',
                        style: TextStyle(
                            color: Constants.maincolor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.005),
                      Text(
                        '${_valueInseam.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3),
                      ),
                    ]),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Constants.maincolor.withOpacity(0.7),
                        inactiveTrackColor: Colors.grey[400]!.withOpacity(0.4),
                        trackShape: RoundedRectSliderTrackShape(),
                        trackHeight: 2.0,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        thumbColor: Constants.maincolor,
                        overlayColor: Colors.red.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 28.0),
                        tickMarkShape: RoundSliderTickMarkShape(),
                        activeTickMarkColor: Constants.maincolor,
                        inactiveTickMarkColor:
                            Constants.maincolor.withOpacity(0.1),
                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                        valueIndicatorColor: Constants.maincolor,
                        valueIndicatorTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Slider(
                        value: _valueInseam,
                        min: 20,
                        max: 60,
                        divisions: 140,
                        label: _valueInseam.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(
                            () {
                              _valueInseam = value;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Shoe: ',
              style: TextStyle(
                  color: Constants.maincolor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.005),
            Text(
              '${_valueShoe.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3),
            ),
          ]),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Constants.maincolor.withOpacity(0.7),
              inactiveTrackColor: Colors.grey[400]!.withOpacity(0.4),
              trackShape: RoundedRectSliderTrackShape(),
              trackHeight: 2.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              thumbColor: Constants.maincolor,
              overlayColor: Colors.red.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: RoundSliderTickMarkShape(),
              activeTickMarkColor: Constants.maincolor,
              inactiveTickMarkColor: Constants.maincolor.withOpacity(0.1),
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: Constants.maincolor,
              valueIndicatorTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            child: Slider(
              value: _valueShoe,
              min: 5,
              max: 20,
              divisions: 140,
              label: _valueShoe.toStringAsFixed(0),
              onChanged: (value) {
                setState(
                  () {
                    _valueShoe = value;
                  },
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
              child: Text(
                'Characteristics',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
                //   textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          Constants.gender == 1
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16),
                      child: Text(
                        'Breast Size',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.orange[200],
                            letterSpacing: 0.4),
                        //   textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: mQ.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: ToggleSwitch(
                            minWidth: double.infinity,
                            cornerRadius: 10.0,
                            activeBgColor: [Constants.maincolor],
                            activeFgColor: Colors.black87,
                            inactiveBgColor: Colors.transparent,
                            inactiveFgColor: Colors.white70,
                            fontSize: 16,
                            labels: ['A', 'B', 'C', 'D', 'D++'],
                            initialLabelIndex: _cupzise,
                            //     icons: [
                            //  FaIcon(FontAwesomeIcons.facebook),
                            //       Icons.shopping_bag,
                            //       Icons.shopping_bag
                            //     ],
                            onToggle: (index) {
                              print('switched to: $index');
                              setState(() {
                                _cupzise = index!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mQ.height * 0.02),
                  ],
                ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
            child: Text(
              'Hair Color',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.orange[200],
                  letterSpacing: 0.4),
              //   textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: mQ.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ToggleSwitch(
                  minWidth: double.infinity,
                  cornerRadius: 10.0,
                  activeBgColor: [Constants.maincolor],
                  activeFgColor: Colors.black87,
                  inactiveBgColor: Colors.transparent,
                  inactiveFgColor: Colors.white70,
                  fontSize: 16,
                  labels: ['Blonde', 'Brown', 'Red', 'Black'],
                  initialLabelIndex: _hairColor,
                  //     icons: [
                  //  FaIcon(FontAwesomeIcons.facebook),
                  //       Icons.shopping_bag,
                  //       Icons.shopping_bag
                  //     ],
                  onToggle: (index) {
                    print('switched to: $index');
                    setState(() {
                      _hairColor = index!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: mQ.height * 0.02),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
            child: Text(
              'Eye Color',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.orange[200],
                  letterSpacing: 0.4),
              //   textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: mQ.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ToggleSwitch(
                  minWidth: double.infinity,
                  cornerRadius: 10.0,
                  activeBgColor: [Constants.maincolor],
                  activeFgColor: Colors.black87,
                  inactiveBgColor: Colors.transparent,
                  inactiveFgColor: Colors.white70,
                  fontSize: 16,
                  labels: ['Brown', 'Green', 'Blue', 'Hazel'],
                  initialLabelIndex: _eyeColor,
                  //     icons: [
                  //  FaIcon(FontAwesomeIcons.facebook),
                  //       Icons.shopping_bag,
                  //       Icons.shopping_bag
                  //     ],
                  onToggle: (index) {
                    print('switched to: $index');
                    setState(() {
                      _eyeColor = index!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: mQ.height * 0.06),
          GestureDetector(
            onTap: () {
              if (Constants.gender == -1) {
                Fluttertoast.showToast(
                    msg: 'Gender not selected',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER);
              } else {
                if (Constants.gender == 0 || Constants.gender == 2) {
                  if (_cupzise == -1 || _hairColor == -1 || _eyeColor == -1) {
                    Fluttertoast.showToast(
                        msg: 'please select all the characteristics',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER);
                  } else {
                    messageAllert(
                        'You\'re about to submit your application for review, Are you sure everything looks ok?',
                        'Umm');
                  }
                } else {
                  if (_hairColor == -1 || _eyeColor == -1) {
                    Fluttertoast.showToast(
                        msg: 'please select all the characteristics',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER);
                  } else {
                    messageAllert(
                        'You\'re about to submit your application for review, Are you sure everything looks ok?',
                        'Umm');
                  }
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(143, 148, 251, 1),
                      Color.fromRGBO(143, 148, 251, .6),
                    ])),
                child: Center(
                  child: Text(
                    "Submit Application",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: mQ.height * 0.02),
        ],
      ),
    );
  }
}
