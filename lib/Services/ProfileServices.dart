import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truthinx/Models/AppUser.dart';

class ProfileServices {
  StreamController<AppUser> loggedInUserStream =
      StreamController.broadcast(sync: true);

  ProfileServices() {
    getLocalUser();
  }

  Future getFirebaseUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get();

    AppUser appUser = AppUser.fromMap(userData.data() as Map<String, dynamic>);
    loggedInUserStream.add(appUser);
  }

  Future<AppUser> getLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> userData = prefs.getStringList("userData") ?? [];
    List<String> categories = await getUserCategories();
    return AppUser.fromPreferences(userData, categories);
  }

  Future<List<String>> getUserCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> categories = prefs.getStringList("categ") ?? [];
    print(categories);
    return categories;
  }
}
