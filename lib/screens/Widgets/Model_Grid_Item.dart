import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/screens/Dashboard/ModelHire/ModelDetails.dart';
import 'package:truthinx/utils/constants.dart';

class GridProduct extends StatelessWidget {
  final String name;
  final String? img;
  final bool isVerified;
  final double rating;
  final int raters;
  final String gender;
  final DocumentSnapshot details;
  final bool isClient;

  GridProduct(
      {Key? key,
      required this.name,
      this.img,
      required this.isVerified,
      required this.rating,
      required this.raters,
      required this.details,
      required this.isClient,
      required this.gender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        // shrinkWrap: true,
        // primary: false,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 2.8,
                width: MediaQuery.of(context).size.width / 2,
                color: Color(0xFFF9EDE0),
                child: Hero(
                  tag: details.hashCode,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0.0),
                    child: img == "default"
                        ? Image.asset('assets/userP.png', fit: BoxFit.contain)
                        : Image.network(
                            img!,
                            fit: BoxFit.cover,
                          ),
                    //     FadeInImage.assetNetwork(
                    //   placeholder: 'assets/placeholder.png',
                    //   image: "$img",
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Row(children: [
                    //   Container(
                    //     color: Colors.black.withOpacity(0.4),
                    //     height: MediaQuery.of(context).size.height * 0.028,
                    //     //  width: MediaQuery.of(context).size.width / 2,
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //       child: Row(
                    //         children: [
                    //           Row(
                    //             children: [
                    //               Text(
                    //                 '5.0 ',
                    //                 style: TextStyle(
                    //                     color: Colors.white, fontSize: 10),
                    //               ),
                    //               Icon(
                    //                 Icons.star,
                    //                 color: Constants.maincolor,
                    //                 size: 12,
                    //               )
                    //             ],
                    //           ),
                    //           SizedBox(width: 4),
                    //           Text(
                    //             '\$125 HR',
                    //             style: TextStyle(
                    //                 color: Colors.orange[300], fontSize: 12),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ]),
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$name',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  gender,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          RawMaterialButton(
                            onPressed: () {},
                            // fillColor: Colors.white,
                            shape: CircleBorder(),
                            elevation: 10.0,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                !isVerified
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.check_circle,
                                color:
                                    isVerified ? Constants.green : Colors.grey,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ModelDetails(modelDetail: details, isClient: isClient);
            },
          ),
        );
      },
    );
  }
}
