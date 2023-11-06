import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/screens/Dashboard/ModelHire/FullImage.dart';

class Portfolio extends StatelessWidget {
  final List<dynamic> bestPhotos;
  Portfolio({required this.bestPhotos});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(bestPhotos.length, (index) {
                return Hero(
                  tag: bestPhotos[index],
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullImage(
                              bestPhotos[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: 200,
                        margin: EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: NetworkImage(
                                bestPhotos[index],
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
