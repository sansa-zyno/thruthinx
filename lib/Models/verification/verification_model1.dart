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
import 'package:truthinx/Models/verification/nudity.dart';
import 'package:truthinx/utils/constants.dart';
import 'package:intl/date_symbol_data_local.dart';

class ModelVerification1 extends StatefulWidget {
  ModelVerification1({Key? key}) : super(key: key);

  @override
  _ModelVerification1State createState() => _ModelVerification1State();
}

class _ModelVerification1State extends State<ModelVerification1> {
  late File _image;

  double _value = 40;
  final _formKeyzipcode = GlobalKey<FormState>();
  final _formKeyphone = GlobalKey<FormState>();
  final _formKeyfacebook = GlobalKey<FormState>();
  final _formKeyinstagram = GlobalKey<FormState>();

  String? imageUrl;
  String? modelVerificationimageUrl;
  bool _imageLoading = false;
  bool _vimageLoading = false;
  String? formatter;

  DateTime now = DateTime.now();

  TextEditingController _dob = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _modelName = TextEditingController();

  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('user');

  final _formKeyHomeAddress = GlobalKey<FormState>();

  //Home Address
  TextEditingController _houseNo = TextEditingController();
  TextEditingController _aptNo = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _zipcode = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _facebookController = TextEditingController();

  TextEditingController _instagramController = TextEditingController();

  void _timeNow() {
    formatter = DateFormat.yMMMMd('en_US').format(now);
    print(formatter);
  }

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
            .child('ModelProfile/$timekey')
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

  _uploadVerificationImage() async {
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
          _vimageLoading = true;
        });
        //Upload to Firebase
        //
        //
        DateTime now = DateTime.now();
        String timekey = now.toString();
        var snapshot = await _firebaseStorage
            .ref()
            .child('Modelverification/$timekey')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          modelVerificationimageUrl = downloadUrl;

          _vimageLoading = false;

          print(modelVerificationimageUrl);
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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    //   new DateFormat.yMMMMd('en_US')
  }

  bool isLoading = false;

  //firebase api call
  void hitStep1() {
    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    collectionReferenceUser.doc(user!.uid).set({
      "profile_pic": imageUrl,
      "verif_image": modelVerificationimageUrl ?? '',
      "hourly_rate": _value.toStringAsFixed(0) ?? '',
      "daily_rate": (_value * 6).toStringAsFixed(0) ?? '',
      "model_name": _modelName.text ?? '',
      "dob": _dob.text ?? '',
      "phone_no": _phoneNumber.text ?? '',
      "house_no": _houseNo.text ?? '',
      "apt_unit_no": _aptNo.text ?? '',
      "city": _city.text ?? '',
      "zipcode": _zipcode.text ?? '',
      "state": _state.text ?? '',
      "facebook": _facebookController.text ?? '',
      "instagram": _instagramController.text ?? '',
    }, SetOptions(merge: true)).then((res) {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Nudity()),
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
    final mQ = MediaQuery.of(context).size;
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
      body: Container(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Our platform requires these pieces of information for a safer booking environment for clients and models alike.',
                        style: TextStyle(
                            fontSize: 16,
                            // color: Constants.maincolor,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Primary Photo',
                        style: TextStyle(
                            fontSize: 22,
                            // color: Constants.maincolor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10),
                      child: Text(
                        'This is your headshot that clients see when searching for talent',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.4,
                            color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  //profile image
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Stack(
                    children: [
                      Center(
                        child: new Container(
                          width: mQ.width * 0.45,
                          height: mQ.height * 0.35,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 1.5)),
                          child: (imageUrl != null)
                              ? Image.network(
                                  imageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/model.jpeg",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        //  right: 20.0,
                        bottom: 15.0,
                        left: 20,
                        child: _imageLoading
                            ? Padding(
                                padding: const EdgeInsets.only(left: 65.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : InkWell(
                                onTap: _uploadImage,
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

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 6.0,
                      ),
                      child: Text(
                        'Tap to edit'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 0.4,
                            color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  imageUrl == null
                      ? Container()
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 1.0,
                            ),
                            child: Text(
                              '$formatter',
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 0.4,
                                  color: Colors.white54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

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
                        'Before you start receiving bookings requests, Please verify your identity upload a clear picture of yourself holding your ID/driver\'s license. Your full name and date of birth must display clearly to read (No glasses, no makeup – you\'re more than welcome to cross out your ID/driver license number',
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
                              shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: (modelVerificationimageUrl != null)
                              ? Image.network(
                                  modelVerificationimageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/verifyPholder.png',
                                  fit: BoxFit.fill,
                                ),
                        ),
                        Positioned(
                          right: 10.0,
                          bottom: 10.0,
                          child: _vimageLoading
                              ? CircularProgressIndicator()
                              : InkWell(
                                  onTap: _uploadVerificationImage,
                                  child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                          color: Colors.grey.withOpacity(0.5)),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Communication',
                        style: TextStyle(
                            fontSize: 22,
                            // color: Constants.maincolor,
                            fontWeight: FontWeight.w400),
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
                            color: Colors.white70),
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

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Rate',
                        style: TextStyle(
                            fontSize: 22,
                            // color: Constants.maincolor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10),
                      child: Text(
                        'Your "Day Rate" is fixed that a client will pay you for 6-8 hours of work in a single day. Based on your hourly rate, we will recommend an appropriate day rate',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.4,
                            color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(children: [
                          Text(
                            '\$ ${_value.toStringAsFixed(0)}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005),
                          Text(
                            'Hourly Rate',
                            style: TextStyle(
                                color: Constants.maincolor,
                                fontSize: 23,
                                fontWeight: FontWeight.w300),
                          )
                        ]),
                        Column(children: [
                          Text(
                            '\$ ${(_value * 6).toStringAsFixed(0)}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005),
                          Text(
                            'Day Rate',
                            style: TextStyle(
                                color: Constants.maincolor,
                                fontSize: 23,
                                fontWeight: FontWeight.w300),
                          )
                        ]),
                      ]),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Constants.maincolor.withOpacity(0.7),
                      inactiveTrackColor: Colors.red[100],
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
                      value: _value,
                      min: 25,
                      max: 725,
                      divisions: 140,
                      label: _value.toStringAsFixed(0),
                      onChanged: (value) {
                        setState(
                          () {
                            _value = value;
                          },
                        );
                      },
                    ),
                  ),

                  // WaveSlider(
                  //   displayTrackball: true,
                  //   color: Constants.maincolor,
                  //   onChanged: (double dragUpdate) {
                  //     setState(() {
                  //       _value = dragUpdate * 750;
                  //       print(
                  //           _value); // dragUpdate is a fractional value between 0 and 1
                  //     });
                  //   },
                  // ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Your Best Photos',
                        style: TextStyle(
                            fontSize: 22,
                            // color: Constants.maincolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload',
                          style: TextStyle(
                              fontSize: 18,
                              // color: Constants.maincolor,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '-Be Creative and add more than 3 for higher chances of acceptance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '-High resolution photos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '-Tall Vertical Images',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '-Upclose full body and close-up facial potraits',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 22),
                        Text(
                          'Don\'tUpload',
                          style: TextStyle(
                              fontSize: 18,
                              // color: Constants.maincolor,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '-Group Photos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '-Low Resolution',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '-Screenshots from other Apps',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '-Selfies',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '-Photos like 2 years ago',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '-Instagram filters photo',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '-Nudity',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '-With watermarks',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    children: [
                      new Container(
                        width: mQ.width * 0.4,
                        height: mQ.height * 0.3,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white, width: 1.5)),
                        child: (_image != null)
                            ? Image.file(
                                _image,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/model.jpeg",
                                fit: BoxFit.fill,
                              ),
                      ),
                      SizedBox(width: 15),
                      new Container(
                        width: mQ.width * 0.4,
                        height: mQ.height * 0.3,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white, width: 1.5)),
                        child: (_image != null)
                            ? Image.file(
                                _image,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/model.jpeg",
                                fit: BoxFit.fill,
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Where are you?',
                        style: TextStyle(
                            fontSize: 22,
                            // color: Constants.maincolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10),
                      child: Text(
                        'Setting a Zipcode let other know Your general locaiton of availability',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.4,
                            color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                  Padding(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Form(
                          key: _formKeyzipcode,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Zipcode",
                                isDense: true,
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.grey[400])),
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
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Phone Number',
                        style: TextStyle(
                            fontSize: 22,
                            // color: Constants.maincolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10),
                      child: Text(
                        'Your phone number will be private to us, we might contact you regarding a job. ',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.4,
                            color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                  Padding(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Form(
                        key: _formKeyphone,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "(555)867-7890",
                                isDense: true,
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.grey[400])),
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
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Model name',
                        style: TextStyle(
                            fontSize: 22,
                            // color: Constants.maincolor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10),
                      child: Text(
                        'This will be your display name that the client will see. If no display name is provided, your first name will display by default.',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.4,
                            color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                  Padding(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "@smarty",
                              isDense: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(color: Colors.grey[400])),
                          controller: _modelName,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Form(
                    key: _formKeyHomeAddress,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 6),
                          child: Text(
                            'Date of Birth:',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white70),
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
                                  hintText: "22-3-1998",
                                  isDense: true,
                                  fillColor: Colors.white,
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
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
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 6),
                          child: Text(
                            'Address',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white70),
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
                                  hintText: "House Address",
                                  isDense: true,
                                  fillColor: Colors.white,
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),

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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "APT unit number",
                                  isDense: true,
                                  fillColor: Colors.white,
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "City",
                                  isDense: true,
                                  fillColor: Colors.white,
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
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
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                    child: Container(
                      width: double.infinity,

                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      //padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).indicatorColor,
                            width: 0.5),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
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
                                    MediaQuery.of(context).size.height * 0.01),

                            Form(
                              key: _formKeyfacebook,
                              child: Padding(
                                padding: EdgeInsets.only(left: 14, right: 14),
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "profile link ",
                                          isDense: true,
                                          fillColor: Colors.white,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                      controller: _facebookController,
                                      keyboardType: TextInputType.url,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'profile link required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  'Instagram',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Constants.maincolor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Instagram username',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            Form(
                              key: _formKeyinstagram,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "@jhon_0",
                                        isDense: true,
                                        fillColor: Colors.white,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                    controller: _instagramController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'instagram profile required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),

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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),

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
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3),
                                ),
                                color: Constants.maincolor,
                                onPressed: () {
                                  if (imageUrl == null) {
                                    Fluttertoast.showToast(
                                        msg: 'Profile photo required',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER);
                                  } else {
                                    if (modelVerificationimageUrl == null) {
                                      Fluttertoast.showToast(
                                          msg: 'Verification photo required',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER);
                                    } else {
                                      if (_formKeyzipcode.currentState!
                                          .validate()) {
                                        if (_formKeyphone.currentState!
                                            .validate()) {
                                          if (_formKeyHomeAddress.currentState!
                                              .validate()) {
                                            if (_facebookController
                                                    .text.isEmpty &&
                                                _instagramController
                                                    .text.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Provide atleast one in instagram and facebook',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER);
                                            } else {
                                              hitStep1();
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: 'Fill up above feilds',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER);
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Phone Number required',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER);
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Zipcode required',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER);
                                      }
                                    }
                                  }
                                }),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
