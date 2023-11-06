import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModelAttributes extends StatelessWidget {
  final List<dynamic> attributes;
  ModelAttributes({required this.attributes});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(attributes.length, (index) {
          return ListTile(
            title: Text(
              attributes[index].toString(),
            ),
          );
        }),
      ),
    );
  }
}
