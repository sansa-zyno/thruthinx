import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageContainer extends StatefulWidget {
  final Function changeImage;
  ImageContainer({required this.changeImage});

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  late File fileImage;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("getImageCalled");
        getImage();
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: 190,
        width: 135,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(5),
          /*image: DecorationImage(
              image: fileImage != null
                  ? FileImage(fileImage)
                  : AssetImage(
                      "assets/model.jpeg",
                    ),
              fit: BoxFit.cover),*/
        ),
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

    var permissionStatus = await Permission.photos.status;
    if (!permissionStatus.isGranted) {
      await Permission.photos.request();
    }

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          fileImage = File(image!.path);
          widget.changeImage(fileImage);
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
