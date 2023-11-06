import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truthinx/Services/NotificationServices.dart';
import 'package:truthinx/screens/Dashboard/Bookings/ModelBookings.dart';
import 'package:truthinx/screens/Dashboard/MyProposals/ModelProposals.dart';
import 'package:truthinx/screens/Dashboard/Subscriptions/Subscription.dart';
import 'package:truthinx/screens/Dashboard/bottomTabs/client_info.dart';

import 'package:truthinx/screens/Startup_screens/welcome.dart';

class ModelDrawer extends StatelessWidget {
  const ModelDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Truthin-X"),
            accountEmail: Text(""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Center(
                child: Text(
                  "X",
                  style: TextStyle(
                      fontSize: 44,
                      fontFamily: GoogleFonts.dancingScript().fontFamily),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text("Account Verification"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClientInfo()));
            },
          ),
          ListTile(
            leading: Icon(Icons.history_rounded),
            title: Text("History"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.home_repair_service_rounded),
            title: Text("My Proposals"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModelProposals(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.donut_large_rounded),
            title: Text("Subscriptions"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subscriptions(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.event_note_rounded),
            title: Text("My Bookings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModelBookings(),
                ),
              );
            },
          ),
          Expanded(child: Center()),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Welcome()),
                  (route) => false);
            },
          )
        ],
      ),
    );
  }
}
