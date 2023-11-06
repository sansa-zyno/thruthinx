import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModelSkills extends StatelessWidget {
  final List<dynamic> skills;
  ModelSkills({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(skills.length, (index) {
          return ListTile(
            title: Text(
              skills[index].toString().split("***")[0],
            ),
            trailing: Text(skills[index].toString().split("***")[1].trimLeft()),
          );
        }),
      ),
    );
  }
}
