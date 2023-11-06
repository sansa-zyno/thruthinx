import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HeadShotImageContainer extends StatefulWidget {
  final Function changeImage;
  HeadShotImageContainer({required this.changeImage});
  @override
  _HeadShotImageContainerState createState() => _HeadShotImageContainerState();
}

class _HeadShotImageContainerState extends State<HeadShotImageContainer> {
  late File headShot;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getImage();
      },
      child: Container(
        height: 220,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          /*image: DecorationImage(
              image: headShot != null
                  ? FileImage(headShot)
                  : AssetImage("assets/model.jpeg")),*/
          //color: Colors.blue,
          border: Border.all(color: Colors.white, width: 1),
        ),
        margin: EdgeInsets.all(10),
        child: Center(
          child: Opacity(
            opacity: 0.5,
            child: Icon(
              Icons.photo_camera,
              size: 36,
            ),
          ),
        ),
      ),
    );
  }

  getImage() async {
    final _imagePicker = ImagePicker();
    XFile? image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          headShot = File(image!.path);
          widget.changeImage(headShot);
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
}
