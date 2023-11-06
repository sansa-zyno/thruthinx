import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truthinx/screens/Dashboard/main_screen_customer.dart';
import 'package:truthinx/screens/Dashboard/main_screen_model.dart';
import 'package:truthinx/screens/Authentication/forgotPassword.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool passwordVisibility = false;

  bool _isLoading = false;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  void logIn() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((result) async {
      //   print(result.additionalUserInfo.username);

      try {
        DocumentSnapshot data = await FirebaseFirestore.instance
            .collection('user')
            .doc(result.user!.uid)
            .get(); //get the data
        await saveUserToPreferences(data.data() as Map<String, dynamic>);
        setState(() {
          _isLoading = false;
        });

        if (data['role'] == 'Client') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreenCustomer(),
              ),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreenModel()),
              (route) => false);
        }
      } catch (e) {
        print(e.toString());
      }

      // else {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => MainScreenCustomer()),
      //   );
      // }
    }).catchError((err) {
      setState(() {
        _isLoading = false;
      });
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
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
        backgroundColor: Colors.black.withOpacity(0.9),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                // SizedBox(height: MediaQuery.of(context).size.height * .1),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/logo.png',
                          height: MediaQuery.of(context).size.height * .22,
                          width: MediaQuery.of(context).size.width * .8,
                        ),
                        Text(
                          'Enter below details',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .03),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 50.0,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
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
                                        return 'Enter Email Address';
                                      } else if (!value.contains('@')) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                    controller: _emailController,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      .015),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: TextFormField(
                                      obscureText:
                                          !passwordVisibility ? true : false,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              icon: passwordVisibility
                                                  ? Icon(Icons.visibility)
                                                  : Icon(Icons.visibility_off),
                                              onPressed: () {
                                                setState(() {
                                                  passwordVisibility =
                                                      !passwordVisibility;
                                                });
                                              }),
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          fillColor: Colors.white,
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter Password';
                                        } else if (value.length < 6) {
                                          return 'Password must be atleast 6 characters!';
                                        }
                                        return null;
                                      },
                                      controller: _passwordController),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    logIn();
                                  }
                                },
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
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 130,
                        ),
                        TextButton(
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> saveUserToPreferences(Map<String, dynamic> map) async {
    String email = map['email'];
    String first_name = map['first_name'];
    String last_name = map['last_name'];
    String role = map['role'];
    String gender = map['gender'];
    String verification = map['verification'];
    String insta = map['instagram_username'] ?? "default";
    List<dynamic> dynamicCetegories = map["categories"] ?? [];
    List<String> categories = [];
    if (dynamicCetegories.isNotEmpty) {
      for (String cat in dynamicCetegories) {
        categories.add(cat);
      }
    }
    print("Login Pending ");
    print(categories);
    List<String> userData = [
      email,
      first_name,
      last_name,
      role,
      gender,
      verification,
      insta,
    ];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("userData", userData);
    prefs.setStringList("categ", categories);
    print(prefs.getStringList("categ"));

    return Future.value(true);
  }
}
