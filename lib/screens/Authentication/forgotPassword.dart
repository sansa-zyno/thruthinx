import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Row(),
              Text(
                "Forgot your password?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Enter your registered email below to receive \npassword reset instrustions",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Lottie.network(
                  "https://assets10.lottiefiles.com/private_files/lf30_GjhcdO.json",
                  height: 300),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16),
                    labelText: "Email",
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(300.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.lightBlue[700],
                  boxShadow: [
                    BoxShadow(
                        color: Colors.lightBlue,
                        spreadRadius: 3,
                        blurRadius: 40),
                  ],
                  borderRadius: BorderRadius.circular(30),
                ),
                width: MediaQuery.of(context).size.width * 0.6,
                child: InkWell(
                    onTap: () {
                      if (emailController.text.isEmpty ||
                          !emailController.text.contains("@") ||
                          !emailController.text.contains(".com")) {
                        Fluttertoast.showToast(
                            msg: "Please enter a valid Email address");
                        return;
                      }

                      FirebaseAuth auth = FirebaseAuth.instance;
                      auth
                          .sendPasswordResetEmail(
                              email: emailController.text.trim())
                          .catchError((onError) {
                        Fluttertoast.showToast(msg: onError.message);
                      }).whenComplete(() {
                        emailController.clear();
                        Fluttertoast.showToast(
                            msg:
                                "Password reset email has been sent, Please check your email");
                      });
                    },
                    child: Center(child: Text("Send"))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
