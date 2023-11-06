import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:truthinx/Models/modelDataModel.dart';
import 'package:truthinx/screens/ModelVerificationScreens/screen5.dart';

class Screen4 extends StatelessWidget {
  final ModelDataModel modelDala;
  Screen4(this.modelDala);
  List<String> skills = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Model Skills"),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CategoryItem(
                      categoryName: "Acting",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Astrology",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Bartending",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Burlesque",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Clown",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Comedian",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Drawing",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Fire Eater/Juggler",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Fortune Teller",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Hosting",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Impressionist",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Improve",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Juggler",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Knitting",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Magician",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Masseuse",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Painting",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Sculpting",
                      selectSkills: selectSkills,
                    ),
                    CategoryItem(
                      categoryName: "Tech-Savvy",
                      selectSkills: selectSkills,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.black,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "Select 1 or more categories that best describe your type of work as a Model",
                        textScaleFactor: 1.4,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      /*shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),*/
                      onPressed: () {
                        print(skills.length);
                        if (skills.isNotEmpty) {
                          modelDala.skills = skills;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Screen5(modelDala)),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please select atleast 1 Skill");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 70),
                        child: Text(
                          "Next",
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

  selectSkills(String value) {
    String exp = value.split("***")[1].trimLeft();
    String skil = value.split("***")[0].trim();
    if (exp == "None") {
      for (String skl in skills) {
        if (skl.split("***")[0].trim() == skil) {
          skills.remove(skl);
          break;
        }
      }
    } else {
      for (String cat in skills) {
        if (cat.split("***")[0].trim() == skil) {
          print("found again");

          skills.remove(cat);
          break;
        }
      }

      skills.add(value);
    }
    print(skills);
  }
}

class CategoryItem extends StatefulWidget {
  final String categoryName;
  final Function selectSkills;
  const CategoryItem({required this.categoryName, required this.selectSkills});
  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool isresponse = false;
  String responseText = "";
  bool isOnTap = false;
  bool isSetNewValue = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: skillSelected,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0.3, color: Colors.white60),
                  bottom: BorderSide(width: 0.3, color: Colors.white60),
                ),
                // color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.categoryName,
                    textScaleFactor: 1.5,
                  ),
                  if (isresponse)
                    Text(
                      responseText,
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.orange),
                    ),
                ],
              ),
            ),
          ),
          if (isOnTap)
            Container(
              height: 80,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSetNewValue = true;
                          responseText = "None";
                        });
                        widget.selectSkills(
                            "${widget.categoryName} *** $responseText");
                        skillSelected();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("None", textScaleFactor: 1.3),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSetNewValue = true;
                          responseText = "Less than 1 year";
                        });

                        widget.selectSkills(
                            "${widget.categoryName} *** $responseText");
                        skillSelected();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("Less than 1 year", textScaleFactor: 1.3),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSetNewValue = true;
                          responseText = "1 Year";
                        });

                        widget.selectSkills(
                            "${widget.categoryName} *** $responseText");
                        skillSelected();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("1 Year", textScaleFactor: 1.3),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSetNewValue = true;
                          responseText = "2 Year";
                        });

                        widget.selectSkills(
                            "${widget.categoryName} *** $responseText");
                        skillSelected();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("2 Year", textScaleFactor: 1.3),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSetNewValue = true;
                          responseText = "3 Year";
                        });

                        widget.selectSkills(
                            "${widget.categoryName} *** $responseText");
                        skillSelected();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("3 Year", textScaleFactor: 1.3),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSetNewValue = true;
                          responseText = "4 Year";
                        });

                        widget.selectSkills(
                            "${widget.categoryName} *** $responseText");
                        skillSelected();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("4 Year", textScaleFactor: 1.3),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSetNewValue = true;
                          responseText = "5+ Year";
                        });

                        widget.selectSkills(
                            "${widget.categoryName} *** $responseText");
                        skillSelected();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("5+ Year", textScaleFactor: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  void skillSelected() {
    setState(() {
      isOnTap = !isOnTap;
      isresponse = true;
      if (!isSetNewValue) {
        // responseText = "Done";
        // if (isOnTap) {
        responseText = "";
      }
    });
  }
}
