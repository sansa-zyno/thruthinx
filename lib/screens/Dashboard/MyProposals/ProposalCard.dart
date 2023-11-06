import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:truthinx/Models/Proposal.dart';
import 'package:truthinx/screens/Dashboard/MyGigs/DescriptionWidget.dart';

class ProposalCard extends StatelessWidget {
  final ClientProposal proposal;
  final int totalProposals;
  final int proposalIndex;
  ProposalCard(
      {required this.proposal,
      required this.proposalIndex,
      required this.totalProposals});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.grey[600],
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      //backgroundImage: proposal.modelDp == "default" ? AssetImage("assets/userP.png") : NetworkImage(proposal.modelDp),
                      backgroundColor: Colors.grey[200],
                      radius: 25,
                    ),
                    title: Text(proposal.modelName),
                    subtitle: Text(DateFormat(DateFormat.YEAR_MONTH_DAY)
                        .format(proposal.time.toDate())),
                  ),
                  AnimatedContainer(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: Duration(milliseconds: 600),
                    child: DescriptionTextWidget(text: proposal.proposal),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
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
                        Text("\$${proposal.rate} / hour")
                      ],
                    ),
                  ),
                ],
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
