import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:truthinx/screens/Dashboard/main_screen_customer.dart';
import 'package:truthinx/utils/constants.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: must_be_immutable
class ClientVerification3 extends StatefulWidget {
  int business;
  ClientVerification3({Key? key, required this.business}) : super(key: key);

  @override
  _ClientVerification3State createState() => _ClientVerification3State();
}

class _ClientVerification3State extends State<ClientVerification3> {
  bool agree = false;

  bool _imageLoading = false;
  DateTime now = DateTime.now();
  String? formatter;
  String? imageUrl;

  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('user');

  TextEditingController _instagramController = TextEditingController();
  TextEditingController _businessUrlController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();

  _uploadImage() async {
    _timeNow();
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
            .child('clientProfile/$timekey')
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
  // firebase api call
  void hitStep3() {
    setState(() {
      isLoading = true;
    });
    String clientRole;

    User? user = FirebaseAuth.instance.currentUser;
    print(formatter);

    collectionReferenceUser.doc(user!.uid).set({
      "dp": imageUrl,
      "notification": 'firebase_messaging token',
      "instagram_username": _instagramController.text ?? '',
      "faceook_username": _facebookController.text ?? '',
      "bus_web_url": _businessUrlController.text ?? '',
      "verification": 'submitted',
      "prof_submitting_time": formatter,
    }, SetOptions(merge: true)).then((res) async {
      setState(() {
        isLoading = false;
      });

      //       Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => MainScreenCustomer(index: 1),
      //   ),
      //   (route) => false,
      // );

      Fluttertoast.showToast(msg: 'success', toastLength: Toast.LENGTH_SHORT);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreenCustomer(index: 1)),
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

  void _timeNow() {
    formatter = DateFormat.yMMMMd('en_US').format(now);
    print(formatter);
  }

  @override
  void initState() {
    // TODO: implement initState

    initializeDateFormatting();

    widget.business = 1;

    //   new DateFormat.yMMMMd('en_US')
  }

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.black.withOpacity(0.2),
        centerTitle: true,
        title: Text(
          'Step 2',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Container(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Profile image',
                      style: TextStyle(
                          fontSize: 22,
                          color: Constants.maincolor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                widget.business == 0
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 10),
                          child: Text(
                            'Please upload a clear headshot picture of yourself ( selfies are okay just make sure it shows your faceclearly. No snapchat, Instagram, Facebook or any sort of filters on your profile picture.',
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0.4,
                                color: Colors.white54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 10),
                          child: Text(
                            'Please upload a clear image that represent your brand or business',
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0.4,
                                color: Colors.white54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                //profile image
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Color(0xff476cfb),
                    child: ClipOval(
                      child: Stack(
                        children: [
                          new SizedBox(
                            width: 160.0,
                            height: 160.0,
                            child: (imageUrl != null)
                                ? Image.network(
                                    imageUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/verifyPholder.PNG',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            right: 20.0,
                            bottom: 15.0,
                            child: _imageLoading
                                ? CircularProgressIndicator()
                                : InkWell(
                                    onTap: _uploadImage,
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        margin:
                                            EdgeInsets.only(left: 70, top: 70),
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
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Communication',
                      style: TextStyle(
                          fontSize: 22,
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
                      'Please enable to receive important notifications from us regarding models you have requested to book or about job listening or other notification we might need to communicate with you',
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.4,
                          color: Colors.white54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: OutlinedButton(
                        onPressed: () {
                          Fluttertoast.showToast(
                              msg: 'Notification enabled successfully',
                              toastLength: Toast.LENGTH_SHORT);
                        },
                        child: Text('Enable Push Notifiactions'),
                      )),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                widget.business == 0
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 10),
                          child: Text(
                            'You must provide one of the two information below',
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0.4,
                                color: Constants.maincolor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 10),
                          child: Text(
                            'You must provide atleast two of the three information below',
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0.4,
                                color: Constants.maincolor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Instagram',
                      style: TextStyle(
                          fontSize: 18,
                          color: Constants.maincolor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Your Instagram username',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),

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
                          prefix: Text(
                            "@   ",
                          ),
                          border: InputBorder.none,
                          hintText: "jhon_0",
                          isDense: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.grey[400])),
                      controller: _instagramController,
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

                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                  child: Container(
                    width: double.infinity,

                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    //padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).indicatorColor, width: 0.5),
                      color: Colors.black.withOpacity(0.7),
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
                              'Facebook',
                              style: TextStyle(
                                  fontSize: 22, color: Constants.maincolor),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.014),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 16),
                            child: Text(
                              'Linking facebook is required',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Padding(
                            padding: EdgeInsets.only(left: 14, right: 14),
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
                                      hintText: "profile link ",
                                      isDense: true,
                                      fillColor: Colors.white,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  controller: _facebookController,
                                  keyboardType: TextInputType.url,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Business website Url required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          // ElevatedButton.icon(
                          //     label: Text('Link Facebook'),
                          //     icon: FaIcon(FontAwesomeIcons.facebook),
                          //     style: ElevatedButton.styleFrom(
                          //       primary: Colors.blue[900], // background
                          //       // foreground
                          //     ),
                          //     onPressed: () {
                          //       // Navigator.push(
                          //       //   context,
                          //       //   MaterialPageRoute(
                          //       //       builder: (context) => ClientVerification1()),
                          //       // );
                          //     }),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                        ],
                      ),
                    ),
                  ),
                ),

                widget.business == 0
                    ? Container()
                    : Column(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Your Website',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Constants.maincolor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.003),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 10),
                              child: Text(
                                'This must point to a valid business website or personal portfolio',
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.4,
                                    color: Colors.white54),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Padding(
                            padding: EdgeInsets.only(left: 14, right: 14),
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
                                      hintText: "http://",
                                      isDense: true,
                                      fillColor: Colors.white,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  controller: _businessUrlController,
                                  keyboardType: TextInputType.url,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Business website Url required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Checkbox(
                        activeColor: Constants.maincolor,
                        value: agree,
                        onChanged: (value) {
                          setState(() {
                            agree = value!;
                            print(agree);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10),
                        child: Text(
                          'I have read and understand the relevant terms of use & privacy policy',
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0.4,
                              color: Colors.white54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: mQ.height * 0.01,
                ),

                isLoading
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CupertinoButton(
                            child: Text(
                              'Submit Profile',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3),
                            ),
                            color: Constants.maincolor,
                            onPressed: () {
                              if (imageUrl != null) {
                                if (widget.business == 0) {
                                  if (_instagramController.text == null &&
                                      _facebookController.text == null) {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Please provide atleast one of the two details above',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER);
                                  } else {
                                    if (agree == false) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please accept terms and conditions',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER);
                                    } else {
                                      hitStep3();
                                    }
                                  }
                                } else {
                                  if (_instagramController.text == null &&
                                      _facebookController.text == null &&
                                      _businessUrlController == null) {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Please provide atleast two of the three details above',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER);
                                  } else {
                                    if (agree == false) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please accept terms and conditions',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER);
                                    } else {
                                      hitStep3();
                                    }
                                  }
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please select Profile image',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER);
                              }
                            }),
                      ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
