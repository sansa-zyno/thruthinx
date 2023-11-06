import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  final String image;
  FullImage(this.image);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: image,
            child: Image.network(image, fit: BoxFit.cover,)),
        ),

        Positioned(
          top: 30,
          left:10,
          child: Card(shape: CircleBorder(), child: IconButton(icon:Icon(Icons.arrow_back_ios_rounded), onPressed: (){Navigator.pop(context);},)))
      ]),
    );
  }
}
