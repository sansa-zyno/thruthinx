import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truthinx/screens/Dashboard/main_screen_customer.dart';
import 'package:truthinx/screens/Dashboard/main_screen_model.dart';
import 'package:truthinx/Models/AppUser.dart';
import 'package:truthinx/utils/constants.dart';

class EditCategories extends StatefulWidget {
  final AppUser userData;
  EditCategories(this.userData);
  @override
  _EditCategoriesState createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  @override
  void initState() {
    super.initState();
  }

  bool flag = true;
  saveCategories() async {
    bool selected = false;
    for (int i = 0; i < categoryIndex.length; i++) {
      if (categoryIndex[i] == 1) {
        selected = true;
        break;
      }
    }
    if (selected) {
      //Save categories to database
      List<String> selectedCategories = [];
      for (int i = 0; i < categoryIndex.length; i++) {
        if (categoryIndex[i] == 1) {
          selectedCategories.add(categories[i]);
        }
      }
      User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection("user")
          .doc(user!.uid)
          .update({"categories": selectedCategories});
      Fluttertoast.showToast(msg: "Categories Successfully updated");

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setStringList("cetegories", selectedCategories);
      if (widget.userData.role == "Client") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreenCustomer()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreenModel()),
            (route) => false);
      }
    } else {
      //Show toast to select atleast one of the categories
      Fluttertoast.showToast(msg: "Please select atleast one category");
    }
  }

  Future<List<int>> getCategories() async {
    if (flag) {
      try {
        if (widget.userData.cetegories != null &&
            widget.userData.cetegories!.isNotEmpty) {
          for (String cat in widget.userData.cetegories!) {
            int index = categories.indexOf(cat);
            categoryIndex[index] = 1;
          }
          print("IN");
        }
        print("OUt");
      } catch (e) {
        print(e.toString());
      }
      flag = false;
    }

    return Future.value(categoryIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Business Categories"),
        actions: [
          TextButton(
              onPressed: () {
                saveCategories();
              },
              child: Text("Save"))
        ],
      ),
      body: FutureBuilder<List<int>>(
          future: getCategories(),
          builder: (context, AsyncSnapshot<List<int>> snapshot) {
            print(snapshot.data);
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: 35,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        enabled: true,
                        onTap: () {
                          switch (categoryIndex[index]) {
                            case 1:
                              setState(() {
                                categoryIndex[index] = 0;
                              });
                              print(categoryIndex);

                              break;
                            case 0:
                              setState(() {
                                categoryIndex[index] = 1;
                              });
                              print(categoryIndex);
                              break;
                            default:
                          }
                        },
                        title: Text(categories[index]),
                        trailing: categoryIndex[index] == 1
                            ? Icon(
                                Icons.check,
                                color: Colors.amberAccent[700],
                              )
                            : SizedBox(height: 1),
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
