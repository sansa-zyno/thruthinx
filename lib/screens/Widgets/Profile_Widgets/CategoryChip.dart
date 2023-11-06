import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final categoryText;
  CategoryChip(this.categoryText);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey
      
      ),
      child: Text(categoryText)
    );
  }
}