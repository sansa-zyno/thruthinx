import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:truthinx/screens/Dashboard/ClientVerification/verification_client3.dart';
import 'package:truthinx/utils/constants.dart';

class ClientVerification1 extends StatefulWidget {
  ClientVerification1({Key? key}) : super(key: key);

  @override
  _ClientVerification1State createState() => _ClientVerification1State();
}

class _ClientVerification1State extends State<ClientVerification1> {
  bool _lights = false;
  bool _imageLoading = false;

  int clientSelection = 0;

  String? imageUrl;
  final _formKeyDOB = GlobalKey<FormState>();
  final _formKeyPhoneNo = GlobalKey<FormState>();
  final _formKeyBuisnessContacts = GlobalKey<FormState>();
  final _formKeyHomeAddress = GlobalKey<FormState>();
  final _formKeyBuisnessAddress = GlobalKey<FormState>();

  TextEditingController _dob = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _cellNumber = TextEditingController();
  TextEditingController _directBusinessNumber = TextEditingController();
  TextEditingController _extraCellNo = TextEditingController();
  TextEditingController _businessEmail = TextEditingController();
  //Home Address
  TextEditingController _houseNo = TextEditingController();
  TextEditingController _aptNo = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _zipcode = TextEditingController();
  TextEditingController _state = TextEditingController();

  //Business Address
  TextEditingController _houseNoB = TextEditingController();
  TextEditingController _aptNoB = TextEditingController();
  TextEditingController _cityB = TextEditingController();
  TextEditingController _zipcodeB = TextEditingController();
  TextEditingController _stateB = TextEditingController();

  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('user');

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    XFile? image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.pickImage(source: ImageSource.gallery);
      var file = File(image!.path);

      if (image != null) {
        setState(() {
          _imageLoading = true;
        });
        //Upload to Firebase
        //
        //
        DateTime now = DateTime.now();
        String timekey = now.toString();
        var snapshot = await _firebaseStorage
            .ref()
            .child('verificationImages/$timekey')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;

          _imageLoading = false;

          print(imageUrl);
        });
      } else {
        print('No Image Path Received');
        Fluttertoast.showToast(
            msg: 'No Image Received', toastLength: Toast.LENGTH_SHORT);
      }
    } else {
      print('Permission not granted. Try Again with permission access');
      Fluttertoast.showToast(
          msg: 'Permission not granted. Try Again with permission access',
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  bool isLoading = false;

  //firebase api call
  void hitStep1() {
    setState(() {
      isLoading = true;
    });
    String clientRole;

    if (clientSelection == 0) {
      clientRole = 'individual';
    } else {
      clientRole = 'business';
    }
    User? user = FirebaseAuth.instance.currentUser;

    collectionReferenceUser.doc(user!.uid).set({
      "client_role": clientRole,
      "dob": _dob.text ?? '',
      "phone_no": _phoneNumber.text ?? '',
      "cell_no": _cellNumber.text ?? '',
      "direct_b_no": _directBusinessNumber.text ?? '',
      "extra_cellno": _extraCellNo.text ?? '',
      "buisness_email": _businessEmail.text ?? '',
      "house_no": _houseNo.text ?? '',
      "apt_unit_no": _aptNo.text ?? '',
      "city": _city.text ?? '',
      "zipcode": _zipcodeB.text ?? '',
      "state": _state.text ?? '',
      "house_no_b": _houseNoB.text ?? '',
      "apt_unit_no_b": _aptNoB.text ?? '',
      "city_b": _cityB.text ?? '',
      "zipcode_b": _zipcodeB.text ?? '',
      "state_b": _stateB.text ?? '',
      "verif_image": imageUrl,
    }, SetOptions(merge: true)).then((res) {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ClientVerification3(business: clientSelection)),
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
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.black.withOpacity(0.2),
        centerTitle: true,
        title: Text(
          'Step 1',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Container(
              child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Truthin-X background verification',
                      style: TextStyle(
                          fontSize: 18,
                          color: Constants.maincolor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 10),
                    child: Text(
                      'Our platform requires these information’s for safer booking environment for clients and models alike',
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.4,
                          color: Colors.white54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ToggleSwitch(
                        minWidth: MediaQuery.of(context).size.width * 0.35,
                        cornerRadius: 10.0,
                        activeBgColor: [Colors.cyanAccent],
                        activeFgColor: Colors.black87,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        fontSize: 16,
                        labels: ['Individual', 'Business'],
                        initialLabelIndex: clientSelection,
                        //     icons: [
                        //  FaIcon(FontAwesomeIcons.facebook),
                        //       Icons.shopping_bag,
                        //       Icons.shopping_bag
                        //     ],
                        onToggle: (index) {
                          print('switched to: $index');
                          setState(() {
                            clientSelection = index!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                  child: Text(
                    'Date of Birth:',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Form(
                      key: _formKeyDOB,
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "22-3-1998",
                            isDense: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey[400])),
                        controller: _dob,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Date of birth required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                clientSelection == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 6),
                            child: Text(
                              'Phone Number:',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white70),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Form(
                                key: _formKeyPhoneNo,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "(555)867-7890",
                                      isDense: true,
                                      fillColor: Colors.white,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  controller: _phoneNumber,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Phone Number required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Form(
                        key: _formKeyBuisnessContacts,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6),
                              child: Text(
                                'Cell Number',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "(555) 555-1234",
                                      isDense: true,
                                      fillColor: Colors.white,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  controller: _cellNumber,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Cell Number required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6),
                              child: Text(
                                'Direct Business number',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "(555)867-7890",
                                      isDense: true,
                                      fillColor: Colors.white,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  controller: _directBusinessNumber,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Direct Business required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6),
                              child: Text(
                                'Extra Cell No',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "(555)867-7890",
                                      isDense: true,
                                      fillColor: Colors.white,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  controller: _extraCellNo,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Extra Cell No required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6),
                              child: Text(
                                'Business Email',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "john@company.com",
                                      isDense: true,
                                      fillColor: Colors.white,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  controller: _businessEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Business Email No required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 6),
                                child: Text(
                                  '( Must be business url email. No gmail, yahoo, aol etc)',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                          ],
                        ),
                      ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                clientSelection == 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 6),
                        child: Text(
                          'Home Address:',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 6),
                        child: Text(
                          'Authorized Personnel Home Address:',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ),
                Form(
                  key: _formKeyHomeAddress,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "House Number and Street Name",
                                isDense: true,
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.grey[400])),

                            controller: _houseNo,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Feild required';
                              }
                              return null;
                            },
                            // keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "APT unit number etc",
                                isDense: true,
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.grey[400])),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'APT unit number required';
                              }
                              return null;
                            },
                            controller: _aptNo,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "City",
                                isDense: true,
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.grey[400])),
                            controller: _city,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'City required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Zipcode",
                                      isDense: true,
                                      fillColor: Colors.white,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  controller: _zipcode,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Zipcode required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "State",
                                      isDense: true,
                                      fillColor: Colors.white,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  controller: _state,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'State required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                clientSelection == 0
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Buisness Address',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Constants.maincolor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005),
                          MergeSemantics(
                            child: ListTile(
                              title: Text(
                                'Same as home address',
                                style: TextStyle(fontSize: 14),
                              ),
                              leading: CupertinoSwitch(
                                value: _lights,
                                onChanged: (bool value) {
                                  setState(() {
                                    _lights = value;
                                    print(_lights);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  _lights = !_lights;
                                  print(_lights);
                                });
                              },
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Center(
                            child: _lights
                                ? Container()
                                : Form(
                                    key: _formKeyBuisnessAddress,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "House Number and Street Name",
                                                  isDense: true,
                                                  fillColor: Colors.white,
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[400])),
                                              controller: _houseNoB,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Feild required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Suite",
                                                  isDense: true,
                                                  fillColor: Colors.white,
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[400])),
                                              controller: _aptNoB,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Suite required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "City",
                                                  isDense: true,
                                                  fillColor: Colors.white,
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[400])),
                                              controller: _cityB,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'City required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "Zipcode",
                                                        isDense: true,
                                                        fillColor: Colors.white,
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                    controller: _zipcodeB,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Zipcode required';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "State",
                                                        isDense: true,
                                                        fillColor: Colors.white,
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                    controller: _stateB,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'State required';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                        ],
                      ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Please verify yourself',
                      style: TextStyle(
                          fontSize: 20,
                          color: Constants.maincolor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 10),
                    child: Text(
                      'upload a clear picture of yourself holding your ID/driver license. Your full name and date of birth must display clearly to read (No glasses – you’re more than welcome to cross out your ID/driver license number',
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.4,
                          color: Colors.white60),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Center(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            /* image: DecorationImage(image: imageUrl!=null ? NetworkImage(imageUrl,
                               ) : AssetImage('assets/verifyPholder.PNG',)
                               ,
                               fit: imageUrl!=null ? BoxFit.cover : BoxFit.fill ),
                            shape: BoxShape.circle, color: Color(0xFFe0f2f1)*/
                            ),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Positioned(
                        right: 10.0,
                        bottom: 10.0,
                        child: _imageLoading
                            ? CircularProgressIndicator()
                            : InkWell(
                                onTap: uploadImage,
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        color: Colors.grey.withOpacity(0.5)),
                                    margin: EdgeInsets.only(left: 70, top: 70),
                                    child: Icon(
                                      Icons.photo_camera,
                                      size: 35,
                                      color: Colors.white,
                                    )),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 10),
                    child: Text(
                      '(Note: This is for verification purposes – No one will be able to see or have access to this - only Truthin-X Authorized personal will be able to see it for verification purposes)',
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.4,
                          color: Colors.white60),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Center(
                        child: CupertinoButton(
                            child: Text(
                              'Complete Final Steps',
                              // style: TextStyle(color: Constants.maincolor),
                            ),
                            color: Constants.maincolor,
                            onPressed: () {
                              if (_formKeyDOB.currentState!.validate()) {
                                if (clientSelection == 0) {
                                  //client
                                  if (_formKeyPhoneNo.currentState!
                                      .validate()) {
                                    if (_formKeyHomeAddress.currentState!
                                        .validate()) {
                                      if (imageUrl != null) {
                                        hitStep1();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Verification picture required',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER);
                                      }
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Fill up the required feids',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER);
                                  }
                                } else {
                                  //buisness
                                  if (_formKeyBuisnessContacts.currentState!
                                      .validate()) {
                                    if (_formKeyHomeAddress.currentState!
                                        .validate()) {
                                      if (_lights == false) {
                                        print(1234);
                                        if (_formKeyBuisnessAddress
                                            .currentState!
                                            .validate()) {
                                          print(123);
                                          if (imageUrl != null) {
                                            hitStep1();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Verification picture required',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER);
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Feilds required',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER);
                                        }
                                      } else {
                                        print(1236);
                                        if (imageUrl != null) {
                                          hitStep1();
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Verification picture required',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER);
                                        }
                                      }
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Info Required',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER);
                                  }
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Fill up the required feilds',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER);
                              }

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => ClientVerification2()),
                              // );
                            }),
                      ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
