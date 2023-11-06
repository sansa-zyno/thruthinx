import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:truthinx/Models/verification/characteristics.dart';
import 'package:truthinx/utils/constants.dart';

class Nudity extends StatefulWidget {
  @override
  createState() {
    return new NudityState();
  }
}

class NudityState extends State<Nudity> {
  List<RadioModel> sampleData = <RadioModel>[];

  String? nudity;
  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('user');

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    sampleData.add(new RadioModel(false, 'A', 'None'));
    sampleData.add(new RadioModel(false, 'B', 'Partial'));
    sampleData.add(new RadioModel(false, 'C', 'Full'));
  }

  void hitNudity() {
    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    collectionReferenceUser.doc(user!.uid).set({
      "nudity": nudity,
    }, SetOptions(merge: true)).then((res) {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Characteristics()),
      );
      Fluttertoast.showToast(msg: 'success', toastLength: Toast.LENGTH_SHORT);
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
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.black.withOpacity(0.2),
        centerTitle: true,
        title: Text(
          'Nudity',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
            child: Center(
              child: Text(
                'Interested in jobs requiring Nudity?',
                style: TextStyle(
                  color: Constants.maincolor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: sampleData.length,
                itemBuilder: (BuildContext context, int index) {
                  return new InkWell(
                    //highlightColor: Colors.red,
                    splashColor: Constants.maincolor,
                    onTap: () {
                      setState(() {
                        sampleData
                            .forEach((element) => element.isSelected = false);
                        sampleData[index].isSelected = true;
                        nudity = sampleData[index].text;
                      });
                    },
                    child: new RadioItem(
                      sampleData[index],
                    ),
                  );
                },
              ),
            ),
          ),
          isLoading
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CupertinoButton(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, letterSpacing: 0.3),
                        ),
                        color: Constants.maincolor,
                        onPressed: () {
                          if (nudity == null) {
                            Fluttertoast.showToast(
                                msg: 'please select an option',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER);
                          } else {
                            hitNudity();
                          }
                        }),
                  ),
                ),
        ],
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 50.0,
            width: 50.0,
            child: new Center(
              child: new Text(_item.buttonText,
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.white,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color:
                  _item.isSelected ? Constants.maincolor : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Constants.maincolor : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(left: 20.0),
            child: new Text(
              _item.text,
              style: TextStyle(fontSize: 16, letterSpacing: 0.3),
            ),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}
