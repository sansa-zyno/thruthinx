/*import 'package:flutter/material.dart';
import 'package:truthinx/Models/modelDataModel.dart';

class Screen8 extends StatefulWidget {
  ModelDataModel modelData;
  Screen8(this.modelData);
  @override
  _Screen8State createState() => _Screen8State();
}

class _Screen8State extends State<Screen8> {
  bool isOther = false;
  bool isFemale = false;
  bool isMale = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Characteristics"),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Gender",
                          textAlign: TextAlign.left,
                          textScaleFactor: 1.4,
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isOther = true;
                                  isFemale = false;
                                  isMale = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Center(
                                  child: Text(
                                    "Other",
                                    textScaleFactor: 1.4,
                                  ),
                                ),
                                color: isOther ? Colors.green[600] : null,
                              ),
                            ),
                          ),
                          Container(
                            width: 0.8,
                            height: 25,
                            color: Colors.white70,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isOther = false;
                                  isFemale = true;
                                  isMale = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Center(
                                  child: Text(
                                    "Female",
                                    textScaleFactor: 1.4,
                                  ),
                                ),
                                color: isFemale ? Colors.green[600] : null,
                              ),
                            ),
                          ),
                          Container(
                            width: 0.8,
                            height: 25,
                            color: Colors.white70,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isOther = false;
                                  isFemale = false;
                                  isMale = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Center(
                                  child: Text(
                                    "Male",
                                    textScaleFactor: 1.4,
                                  ),
                                ),
                                color: isMale ? Colors.green[600] : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    if (isOther) OtherMenu(),
                    if (isFemale) FemaleMenu(),
                    if (isMale) MaleMenu(),

                    // CategoryItem(categoryName: ""),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.black,
                height: 70,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 5),
                    //   child: Text(
                    //     "Select 1 or more personality attributes that best describe you",
                    //     textScaleFactor: 1.4,
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      /* shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),*/
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 70),
                        child: Text(
                          "Submit Application",
                          textScaleFactor: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OtherMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FemaleMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Settings your measurment allows you tour profile to be found in search results.",
          textScaleFactor: 1.3,
        ),
        SizedBox(height: 20),
        Text(
          "Build",
          textScaleFactor: 1.5,
        ),
        SlideBar(
          divisions: 700,
          itemName: "Height",
          max: 7.0,
          min: 0.0,
        ),
        SlideBar(
          divisions: 280,
          itemName: "Weight",
          max: 280.0,
          min: 0.0,
        ),
      ],
    );
  }
}

class MaleMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SlideBar extends StatefulWidget {
  final String itemName;
  final double min;
  final double max;
  final int divisions;

  const SlideBar(
      {required this.itemName,
      required this.min,
      required this.max,
      required this.divisions});
  @override
  _SlideBarState createState() => _SlideBarState();
}

class _SlideBarState extends State<SlideBar> {
  int _value = 1;
  String? itemName;
  double? min;
  double? max;
  int? divisions;
  @override
  void initState() {
    super.initState();
    itemName = widget.itemName;
    min = widget.min;
    max = widget.max;
    divisions = widget.divisions;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.itemName + ":  ",
                textScaleFactor: 1.5,
                style: TextStyle(color: Colors.orange),
              ),
              Text(
                _value.toString(),
                textScaleFactor: 1.5,
              ),
            ],
          ),
          // FlutterSlider(
          //   values: [10],
          //   min: min,
          //   max: max,
          //   // onDragging: (handlerIndex, lowerValue, upperValue) {
          //   //   _lowerValue = lowerValue;
          //   //   _upperValue = upperValue;
          //   //   setState(() {});
          //   // },
          // ),
          Slider(
            value: _value.toDouble(),
            min: min!,
            max: max!,
            divisions: divisions,
            activeColor: Colors.orange,
            inactiveColor: Colors.grey,
            onChanged: (double newValue) {
              setState(() {
                _value = newValue.round();
              });
            },
          ),
        ],
      ),
    );
  }
}*/
