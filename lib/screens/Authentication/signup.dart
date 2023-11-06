import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truthinx/screens/Dashboard/main_screen_customer.dart';
import 'package:truthinx/screens/Dashboard/main_screen_model.dart';
import 'package:truthinx/utils/constants.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  int _radioValue1 = -1;
  void _handleRadioValueChange1(int? value) {
    setState(() {
      _radioValue1 = value!;

      switch (_radioValue1) {
        case 0:
          Fluttertoast.showToast(
              msg: 'Select Gender!', toastLength: Toast.LENGTH_SHORT);

          break;
        case 1:
          Fluttertoast.showToast(msg: 'Great', toastLength: Toast.LENGTH_SHORT);
          break;
      }
    });
  }

  static final Map<String, String> genderMap = {
    'female': 'Female',
    'male': 'Male',
    'other': 'Other',
  };

  String _selectedGender = genderMap.keys.first;

  void onGenderSelected(String genderKey) {
    setState(() {
      _selectedGender = genderKey;
      print(genderKey);

      if (genderKey == 'male') {
        Constants.gender = 1;
      } else if (genderKey == 'female') {
        Constants.gender = 0;
      } else {
        Constants.gender = 2;
      }
    });
  }

//firebase
//
  bool passwordVisibility = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('user');

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController middlenameController = TextEditingController();
  void saveUserToPreferences(List<String> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("userData", userData);

    prefs.setStringList("categories", []);
  }

  void register() async {
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) async {
      String role;
      if (_radioValue1 == 0) {
        role = 'Model';
      } else {
        role = 'Client';
      }
      var gender = '';
      if (role == "Client") {
        gender = "default";
      } else {
        gender = _selectedGender;
      }
      await FirebaseFirestore.instance
          .collection("notifications")
          .doc(result.user!.uid)
          .set({"allowed": false});
      collectionReferenceUser.doc(result.user!.uid).set({
        "role": role,
        "email": emailController.text.trim(),
        "first_name": _firstName.text.trim(),
        "last_name": _lastName.text.trim(),
        "gender": gender ?? '',
        "verification": "UNKNOWN",
        "dp": "default",
        "instagram_username": "default"
      }).then((res) async {
        setState(() {
          List<String> userData = [
            emailController.text.trim(),
            _firstName.text.trim(),
            _lastName.text.trim(),
            role,
            gender ?? '',
            "Pending",
            "default"
          ];
          saveUserToPreferences(userData);
          isLoading = false;
        });

        if (role == 'Client') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreenCustomer()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreenModel()),
          );
        }

        Fluttertoast.showToast(msg: 'success', toastLength: Toast.LENGTH_SHORT);
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new CupertinoAlertDialog(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('Oops'),
              ),
              content: Text(err.message),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Column(
                    children: <Widget>[
                      Text('Cancel'),
                    ],
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    passwordController.dispose();
    emailController.dispose();
    middlenameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.88),
        body: ListView(
          children: [
            // SizedBox(height: MediaQuery.of(context).size.height * .1),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [Container()],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SignUp',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .3),
                          IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 70.0,
                                offset: Offset(0, 10))
                          ]),
                      child: Column(
                        children: <Widget>[
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
                                    hintText: "First Name",
                                    fillColor: Colors.white,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter First Name';
                                  }
                                  return null;
                                },
                                controller: _firstName,
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * .015),
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
                                    hintText: "Last Name",
                                    fillColor: Colors.white,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Last Name';
                                  }
                                  return null;
                                },
                                controller: _lastName,
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * .015),
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
                                    hintText: "Email",
                                    fillColor: Colors.white,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter an Email Address';
                                  } else if (!value.contains('@') ||
                                      !value.contains(".com")) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                controller: emailController,
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * .015),
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
                                  obscureText:
                                      !passwordVisibility ? true : false,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          icon: !passwordVisibility
                                              ? Icon(Icons.visibility_off)
                                              : Icon(Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              passwordVisibility =
                                                  !passwordVisibility;
                                            });
                                          }),
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      fillColor: Colors.white,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Password';
                                    } else if (value.length < 6) {
                                      return 'Password must be atleast 6 characters!';
                                    }
                                    return null;
                                  },
                                  controller: passwordController),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * .015),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      new Radio(
                        value: 0,
                        activeColor: Constants.maincolor,
                        groupValue: _radioValue1,
                        onChanged: _handleRadioValueChange1,
                      ),
                      Text(
                        'I am a Model',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  _radioValue1 == 0
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              CupertinoRadioChoice(
                                  notSelectedColor: Colors.transparent,
                                  choices: genderMap,
                                  onChange: onGenderSelected,
                                  initialKeyValue: _selectedGender)
                            ],
                          ),
                        )
                      : Container(),
                  Row(
                    children: [
                      new Radio(
                        activeColor: Constants.maincolor,
                        value: 1,
                        groupValue: _radioValue1,
                        onChanged: _handleRadioValueChange1,
                      ),
                      Text(
                        'I Book Models',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (_radioValue1 == -1) {
                                Fluttertoast.showToast(
                                    msg: 'Select between user and model',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER);
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                register();
                              }
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
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
                                  "Join".toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
