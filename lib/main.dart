import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/screens/Startup_screens/splash_screen.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await DotEnv.load(fileName: ".env");
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThuthinX();
  }
}

class ThuthinX extends StatefulWidget {
  @override
  _ThuthinXState createState() => _ThuthinXState();
}

class _ThuthinXState extends State<ThuthinX> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TruthIn-X',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        unselectedWidgetColor: Colors.white,
        brightness: Brightness.light,
        fontFamily: "Nunito",
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.white,
          ),
        ),
        primarySwatch: Colors.orange,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: SplashScreen(),
      //home: Screen8(),
    );
  }
}
