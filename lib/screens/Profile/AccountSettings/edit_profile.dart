import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truthinx/screens/Dashboard/main_screen_customer.dart';
import 'package:truthinx/screens/Dashboard/main_screen_model.dart';
import 'package:truthinx/Models/AppUser.dart';
import 'package:truthinx/screens/Profile/AccountSettings/edit_categories.dart';

class EditProfile extends StatefulWidget {
  final AppUser user;
  EditProfile(this.user);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController f_name = TextEditingController();
  TextEditingController l_name = TextEditingController();
  String selectedGender = '';
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    f_name..text = widget.user.first_name!;
    l_name..text = widget.user.last_name!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Edit Profile",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
                ),
                Divider(),
                SizedBox(height: 20),
                TextField(
                  controller: f_name,
                  enabled: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16),
                    labelText: "First Name",
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(300.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: l_name,
                  enabled: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16),
                    labelText: "LastName",
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(300.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownSearch<String>(
                    // mode: Mode.MENU,
                    //showSelectedItem: true,
                    items: ["Male", "Female", "Others", 'Prefer Not to answer'],
                    //label: "Gender",
                    //hint: "Select Gender",
                    //popupItemDisabled: (String s) => s.startsWith('I'),
                    onChanged: (value) {
                      selectedGender = value!;
                      print(selectedGender);
                    },
                    selectedItem: widget.user.gender != "default"
                        ? widget.user.gender
                        : "Prefer Not to answer",
                    /*searchBoxDecoration: InputDecoration(
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(300),
                    )),*/
                  ),
                ),
                Divider(),
                ListTile(
                  enabled: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCategories(widget.user),
                      ),
                    );
                  },
                  title: Text("Edit Categories"),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  leading: Icon(Icons.category_rounded),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }

            if (!loading) {
              setState(() {
                loading = true;
              });
              updateProfileData();
            }
          },
          label: Text("Update"),
          icon: loading
              ? CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                )
              : Icon(Icons.arrow_upward_outlined)),
    );
  }

  updateProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> userData = prefs.getStringList("userData") ?? [];

    userData[1] = f_name.text.trim();
    userData[2] = l_name.text.trim();
    if (selectedGender.isNotEmpty) {
      userData[4] = selectedGender;
    } else {
      selectedGender = "default";
    }
    User? user = FirebaseAuth.instance.currentUser;
    prefs.setStringList("userData", userData);

    FirebaseFirestore.instance.collection("user").doc(user!.uid).update({
      "first_name": userData[1],
      "last_name": userData[2],
      'gender': selectedGender,
    }).then((value) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "Successfuly Updated Profile Data!");

      if (widget.user.role == "Client") {
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
    });
  }
}
