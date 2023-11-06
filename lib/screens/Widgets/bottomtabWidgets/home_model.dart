import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/screens/Dashboard/search.dart';
import 'package:truthinx/utils/constants.dart';

class HomeScreenModel extends StatefulWidget {
  HomeScreenModel({Key? key}) : super(key: key);

  @override
  _HomeScreenModelState createState() => _HomeScreenModelState();
}

const double width = 330.0;
const double height = 35.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Colors.grey;

class _HomeScreenModelState extends State<HomeScreenModel> {
  double? xAlign;
  Color? loginColor;
  Color? signInColor;

  @override
  void initState() {
    super.initState();
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.black12,
        //   centerTitle: true,
        //   title: Text(
        //     'Info',
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),

        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.22,
              color: Colors.black45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: Row(children: [
                              Text(
                                'Filter',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Icon(Icons.filter_alt_rounded,
                                  color: Colors.white)
                            ])),
                        TextButton(
                            onPressed: () {},
                            child: Row(children: [
                              Text(
                                'Model',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Icon(Icons.arrow_drop_down_sharp,
                                  size: 30, color: Colors.white)
                            ])),
                        IconButton(
                          icon: Icon(Icons.search, size: 30),
                          onPressed: () {
                            Navigator.of(context).push(PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (BuildContext context, _, __) {
                                  return Search();
                                }));
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.017,
                  ),
                  Center(
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            alignment: Alignment(xAlign!, 0),
                            duration: Duration(milliseconds: 300),
                            child: Container(
                              width: width * 0.5,
                              height: height,
                              decoration: BoxDecoration(
                                color: Constants.maincolor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                xAlign = loginAlign;
                                loginColor = selectedColor;

                                signInColor = normalColor;
                              });
                            },
                            child: Align(
                              alignment: Alignment(-1, 0),
                              child: Container(
                                width: width * 0.5,
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  'Top',
                                  style: TextStyle(
                                    color: loginColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                xAlign = signInAlign;
                                signInColor = selectedColor;

                                loginColor = normalColor;
                              });
                            },
                            child: Align(
                              alignment: Alignment(1, 0),
                              child: Container(
                                width: width * 0.5,
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  'All',
                                  style: TextStyle(
                                    color: signInColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.022,
                  )
                ],
              ),
            ),
            // Expanded(
            //   child: GridView.builder(
            //     shrinkWrap: true,
            //     primary: false,
            //     physics: ScrollPhysics(),
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       childAspectRatio: MediaQuery.of(context).size.width /
            //           (MediaQuery.of(context).size.height / 1.4),
            //     ),
//                 itemCount: foods == null ? 0 : foods.length,
//                 itemBuilder: (BuildContext context, int index) {
// //                Food food = Food.fromJson(foods[index]);
//                   Map food = foods[index];
// //                print(foods);
// //                print(foods.length);
//                   return GridProduct(
//                     img: food['img'],
//                     isFav: false,
//                     name: food['name'],
//                     rating: 5.0,
//                     raters: 23,
//                   );
            //},
            //   ),
            // ),
          ],
        ));
  }
}
