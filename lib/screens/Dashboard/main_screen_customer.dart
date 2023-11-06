import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:truthinx/screens/Dashboard/bottomTabs/create_job.dart';
import 'package:truthinx/screens/Dashboard/bottomTabs/home_customer.dart';
import 'package:truthinx/screens/Dashboard/bottomTabs/payments.dart';

import 'package:truthinx/screens/Profile/agent_profile.dart';

class MainScreenCustomer extends StatefulWidget {
  final int? index;
  MainScreenCustomer({Key? key, this.title, this.index}) : super(key: key);

  final String? title;

  @override
  _MainScreenCustomerState createState() => _MainScreenCustomerState();
}

class _MainScreenCustomerState extends State<MainScreenCustomer> {
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
                  icon: Icon(CupertinoIcons.person_2_square_stack),
                  label: "Create Job"),
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
              return CreateJobCustomer();
              break;
            case 2:
              return PaymentsCustomer();
              break;
            case 3:
              return AgentProfile();
              break;

            default:
              return HomeScreenCustomer();
              break;
          }
        });

    //Android Scafold
  }
}
