import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:truthinx/screens/Dashboard/Listings.dart';

import 'package:truthinx/screens/Dashboard/bottomTabs/home_customer.dart';
import 'package:truthinx/screens/Profile/agent_profile.dart';
import 'package:truthinx/screens/Widgets/bottomtabWidgets/home_model.dart';
import 'package:truthinx/screens/Widgets/bottomtabWidgets/payments.dart';

class MainScreenModel extends StatefulWidget {
  final int? index;
  MainScreenModel({Key? key, this.title, this.index}) : super(key: key);

  final String? title;

  @override
  _MainScreenModelState createState() => _MainScreenModelState();
}

class _MainScreenModelState extends State<MainScreenModel> {
  int currentTabIndex = 0;

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  // List<Widget> tabs = [
  //   Home(),
  //   Tour(),
  //   Profile(),
  // ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            currentIndex: widget.index ?? 0,
            backgroundColor: Colors.grey[800],
            activeColor: Colors.orange[300],
            items: [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.chart_bar_square),
                  label: "Listings"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.creditcard), label: "Payments"),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                label: "Profile",
              )
            ]),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return HomeScreenCustomer();
              break;

            case 1:
              return Listings();
              break;
            case 2:
              return PaymentsModel();
              break;
            case 3:
              return AgentProfile();
              break;
            default:
              return HomeScreenModel();

              break;
          }
        });

    //Android Scafold
  }
}
