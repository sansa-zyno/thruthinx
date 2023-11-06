import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final Color backgroundColor = Colors.red;
  final String title;

  final AppBar appBar;
  //final List<CartProductItem> cartList;
  //final Function(List<CartProductItem>) onChange;

  /// you can add more fields that meet your needs

  const BaseAppBar({
    Key? key,
    // this.title,
    required this.appBar,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //automaticallyImplyLeading: false,
      backgroundColor: Colors.black.withOpacity(0.2),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
