import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:truthinx/Models/Gig.dart';
import 'package:truthinx/screens/Dashboard/MyGigs/AllRequests.dart';
import 'package:truthinx/screens/Dashboard/MyGigs/DescriptionWidget.dart';

class GigCard extends StatelessWidget {
  final Gig gig;
  final String docId;
  final int totalProposals;
  final int proposalIndex;
  GigCard(
      {required this.gig,
      required this.proposalIndex,
      required this.totalProposals,
      required this.docId});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.grey[600],
              child: Container(
                child: ListView(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        /*backgroundImage: gig.clientDp == "default"
                            ? AssetImage("assets/userP.png")
                            : NetworkImage(gig.clientDp),*/
                        backgroundColor: Colors.grey[200],
                        radius: 25,
                      ),
                      title: Text(gig.clientName),
                      subtitle: Text(DateFormat(DateFormat.YEAR_MONTH_DAY)
                          .format(gig.dateCreated.toDate())),
                    ),
                    AnimatedContainer(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: Duration(milliseconds: 600),
                      child: DescriptionTextWidget(text: gig.desc),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Image.asset(
                                  "assets/role.png",
                                  height: 24,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text("Role:"),
                              SizedBox(width: 10),
                              Text(gig.role)
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Image.asset(
                                  "assets/gender.png",
                                  height: 24,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text("Gender:"),
                              SizedBox(width: 10),
                              Text(gig.gender),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Image.asset(
                                  "assets/coin-stack.png",
                                  height: 24,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text("Budget:"),
                              SizedBox(width: 10),
                              Text("\$${gig.hourlyRate} / hour")
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      indent: 40,
                      endIndent: 12,
                      thickness: 2,
                    ),
                    AnimatedContainer(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: Duration(milliseconds: 600),
                      child: DescriptionTextWidget(
                          text: "Requirements:\n\n${gig.requirements}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          height: 60,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllRequests(
                                              gig: gig,
                                              docId: docId,
                                            )));
                              },
                              child: Center(
                                  child: Text(
                                "View Requests",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text("$proposalIndex/$totalProposals")
        ],
      ),
    );
  }
}
