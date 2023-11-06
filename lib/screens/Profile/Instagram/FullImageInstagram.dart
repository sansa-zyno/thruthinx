import 'package:flutter/material.dart';

class FullImageInstagram extends StatelessWidget {
  final String url;
  FullImageInstagram(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Hero(
              tag: url,
              child: Image.network(
                url,
                fit: BoxFit.contain,
              ))),
    );
  }
}
