import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:truthinx/Services/ProfileServices.dart';
import 'package:truthinx/Models/AppUser.dart';
import 'package:truthinx/screens/Dashboard/Gig/createGig.dart';
import 'package:truthinx/screens/Dashboard/search.dart';
import 'package:truthinx/utils/constants.dart';

class CreateJobCustomer extends StatefulWidget {
  CreateJobCustomer({Key? key}) : super(key: key);

  @override
  _CreateJobCustomerState createState() => _CreateJobCustomerState();
}

class _CreateJobCustomerState extends State<CreateJobCustomer> {
  AppUser? user;
  ProfileServices profileData = ProfileServices();
  void initState() {
    super.initState();
    profileData.getLocalUser().then((value) {
      setState(() {
        user = value;
        print(user!.verification);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text(
          'Book Talent',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: user == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    'There are two ways to find and\nbook models',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 12, right: 12),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      //padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).indicatorColor,
                            width: 0.5),
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color:
                                Theme.of(context).indicatorColor.withAlpha(100),
                            blurRadius: 16.0,
                            offset: new Offset(0.0, 3.0),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Direct Booking',
                                style: TextStyle(
                                    fontSize: 18, color: Constants.maincolor),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 16),
                              child: Text(
                                'Search the TALENT and select a model that\'s perfectly fits your job needs',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            CupertinoButton(
                                child: Text(
                                  'Start your Search',
                                  style: TextStyle(color: Constants.maincolor),
                                ),
                                color: Colors.white.withOpacity(0.1),
                                onPressed: () {
                                  if (user!.verification != "VERIFIED") {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Only Verified Users can access this section");
                                    return;
                                  }
                                  Navigator.of(context).push(PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder:
                                          (BuildContext context, _, __) {
                                        return Search();
                                      }));
                                }),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 12, right: 12),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      //padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).indicatorColor,
                            width: 0.5),
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color:
                                Theme.of(context).indicatorColor.withAlpha(100),
                            blurRadius: 16.0,
                            offset: new Offset(0.0, 3.0),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Job Listing',
                                style: TextStyle(
                                    fontSize: 18, color: Constants.maincolor),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 16),
                              child: Text(
                                'Post a job, by selecting your desired criteria. So All the relevant models to your gig can apply to you job',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            CupertinoButton(
                                child: Text(
                                  'Create Gig',
                                  style: TextStyle(color: Constants.maincolor),
                                ),
                                color: Colors.white.withOpacity(0.1),
                                onPressed: () {
                                  if (user!.verification != "VERIFIED") {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Only Verified Users can access this section");
                                    return;
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateGig(),
                                    ),
                                  );
                                }),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
