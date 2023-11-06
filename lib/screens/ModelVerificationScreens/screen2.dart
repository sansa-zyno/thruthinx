import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:truthinx/Models/modelDataModel.dart';
import 'package:truthinx/screens/ModelVerificationScreens/screen3.dart';
import 'package:truthinx/screens/Widgets/HeadShotImageContainer.dart';
import 'package:truthinx/screens/Widgets/ImageContainer.dart';
import 'package:truthinx/screens/Widgets/RateCalculator.dart';

class Screen2 extends StatefulWidget {
  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  DateTime _firstDate = DateTime.now().subtract(Duration(days: 350));
  DateTime _lastDate = DateTime.now().add(Duration(days: 350));
  DateTime _selectedDate = DateTime.now();
  bool pushNotificationEnabled = false;
  int rate = -1;
  //List<File> bestPhotos = List(5);
  List<File> bestPhotos = [];
  String zipcode = '';
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  ModelDataModel modelData = ModelDataModel();
  String date = '';
  late File headShot;
  @override
  void dispose() {
    super.dispose();

    instagramController.dispose();
    zipCodeController.dispose();
    phoneController.dispose();
  }

  void _onSelectedDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      date = newDate.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),
              Text(
                "Headshot",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "This is your primary photo that clients see when searching for talent.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              HeadShotImageContainer(changeImage: (value) {
                headShot = value;
              }),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 18.0, top: 8),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      date = _selectedDate.toString();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK"),
                                ),
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  onDateTimeChanged: _onSelectedDateChanged,
                                  initialDateTime: _selectedDate,
                                  minimumDate: _firstDate,
                                  maximumDate: _lastDate,
                                  maximumYear: _selectedDate.year,
                                  minimumYear: _selectedDate.year,
                                  mode: CupertinoDatePickerMode.date,
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Text(
                  "TAP TO EDIT",
                  textScaleFactor: 1.3,
                ),
              ),
              Text(
                date.isEmpty
                    ? "mm/yyyy"
                    : DateFormat('dd-MM-yyyy').format(_selectedDate),
                textScaleFactor: 1.2,
              ),
              SizedBox(height: 20),
              Text(
                "Communication",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "By enabling notifications, you will be notified when a booking request occurs, someone messages you, and when you get paid",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                /*shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),*/
                onPressed: () {
                  setState(() {
                    pushNotificationEnabled = !pushNotificationEnabled;
                  });
                  Fluttertoast.showToast(
                      msg: pushNotificationEnabled
                          ? "Notifications Enabled!"
                          : "Notifications Disabled",
                      backgroundColor: Colors.white);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    !pushNotificationEnabled
                        ? "Enable Notifications"
                        : "Disable Notifications",
                    textScaleFactor: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Rate",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Your \"Day Rate\" is the fixed amount that a client will pay you for 6-8 hours of work in a single day. Based on your hourlyrate, we will recommend an appropriate day rate.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              RateCalculation(changeRate: (value) {
                rate = value;
              }),
              Text(
                "Your 5 Best Photos",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Do NOT upload:",
                    style: TextStyle(
                        fontSize: 18, decoration: TextDecoration.underline),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "-Selfies\n-Group photos\n-Screenshots from other Apps\n-Low resolution\n-Photos with branded watermarks\n-Filters from Instagram or Snapchat\n-Letter-boxed images (photos with black bars)\n-Photos taken over 2 years ago\n-Nudity ",
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Do upload:",
                    style: TextStyle(
                        fontSize: 18, decoration: TextDecoration.underline),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "-High Resolution photos\n-Tall vertical oriented images as opposed to horizontal wide\n-A diverse set of full body, and up-close facial portraits.\n-Be creative and add more than 3 for a higher chance at getting accepted. ",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(5),
                  children: [
                    ImageContainer(changeImage: (image) {
                      // Image 1

                      bestPhotos[0] = image;
                    }),
                    ImageContainer(changeImage: (image) {
                      // Image 2
                      setState(() {
                        bestPhotos[1] = image;
                      });
                    }),
                    ImageContainer(changeImage: (image) {
                      // Image 3
                      setState(() {
                        bestPhotos[2] = image;
                      });
                    }),
                    ImageContainer(changeImage: (image) {
                      // Image 4
                      setState(() {
                        bestPhotos[3] = image;
                      });
                    }),
                    ImageContainer(changeImage: (image) {
                      // Image 5
                      setState(() {
                        bestPhotos[4] = image;
                      });
                    }),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Where are you?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Rather than letting your device tell us where you are, setting a zipcode lets others know your general location of availability",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: zipCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.black45,
                  filled: true,
                  hintText: 'Eg: 90210',
                ),
              ),
              SizedBox(height: 25),
              Text(
                "What's your number?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We recommend using a mobile cell number in the event we might need to contact you regarding a job. Your number will not be visible on your profile, nor shared with others.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.black45,
                  filled: true,
                  hintText: '(310) 555-6789',
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Your Instagram username",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "All Model accounts require an Instagram. Connection to help us verify your identity.             ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: instagramController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.black45,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12),
                    child: Text(
                      "@",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                  filled: true,
                  hintText: 'john',
                ),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                /*shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),*/
                onPressed: () {
                  if (checkUserData()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Screen3(modelData: modelData)),
                    );
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: Text(
                    "Continue",
                    textScaleFactor: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  bool checkUserData() {
    if (headShot == null) {
      Fluttertoast.showToast(msg: "Please select a Headshot");
      return false;
    }
    if (date.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a date for Headshot");
      return false;
    }
    if (rate == -1) {
      Fluttertoast.showToast(msg: "Please select an hourly rate");
      return false;
    }
    if (bestPhotos.length < 5) {
      Fluttertoast.showToast(msg: "Please upload your 5 best photos");
      return false;
    }
    if (zipCodeController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your zipcode");
      return false;
    }
    if (phoneController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your phone Number");
      return false;
    }
    if (instagramController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your instagram Username");
      return false;
    }
    modelData.dp = headShot.path;
    List<String> urls = [];
    for (int i = 0; i < bestPhotos.length; i++) {
      urls.add(bestPhotos[i].path);
    }
    modelData.bestPhotos = urls;
    modelData.dpDate = _selectedDate;
    modelData.enablePushNotifications = pushNotificationEnabled;
    modelData.zipCode = zipCodeController.text.trim();
    modelData.phoneNumber = phoneController.text.trim();
    modelData.instaUserName = instagramController.text.trim();
    modelData.hourlyRate = rate;

    return true;
  }
}
