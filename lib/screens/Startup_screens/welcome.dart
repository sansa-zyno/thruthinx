
import 'package:flutter/material.dart';
import 'package:truthinx/screens/Authentication/login.dart';
import 'package:truthinx/screens/Authentication/signup.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  // bool loaded = false;
//   void check() async{
//     User user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         DocumentSnapshot data = await FirebaseFirestore.instance
//             .collection('user')
//             .doc(user.uid)
//             .get(); //get the data
        
        

//         if (data['role'] == 'Client') {
//           Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MainScreenCustomer(),
//               ),
//               (route) => false);
//         } else {
//           Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => MainScreenModel()),
//               (route) => false);
//         }
//       } catch (e) {
//         print(e.message);
//       }

//     }
//     else{
//       setState(() {
//         loaded = true;
//       });
//     }

// //     else {
// // // log in
// //     }
//   }

  @override
  void initState() {
    // Future.delayed(Duration.zero, () async {
    //   check();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/model.jpeg"), 
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,

                    child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/logo.png'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return Login();
                        }));
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.7,
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
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return SignUp();
                        }));
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.2)),
                    child: Center(
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
