import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:truthinx/Models/modelDataModel.dart';
import 'package:truthinx/screens/ModelVerificationScreens/screen4.dart';

class Screen3 extends StatelessWidget {
  ModelDataModel modelData;
  Screen3({required this.modelData});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
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
                        categoryName: "Beauty", selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Commercial",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "E-commerce",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Editorial",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Fitness",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Fittings",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Hair", selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "High Fashion",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Lifestyle",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Parts - Arms",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Parts - Ears",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Parts - Eyes",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Parts - Feet",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Parts - Hands",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Parts - Legs",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Parts - Lips/Smile",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Parts - Neck",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Parts - Skin",
                        selectCategory: selectCategory),
                    CategoryItem(
                        categoryName: "Parts - Torso",
                        selectCategory: selectCategory),
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
                        print(categories.length);
                        if (categories.isNotEmpty) {
                          modelData.categories = categories;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Screen4(modelData)),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please select atleast 1 category");
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

  List<String> categories = [];
  selectCategory(String value) {
    String exp = value.split("***")[1].trimLeft();
    String categ = value.split("***")[0].trim();
    if (exp == "None") {
      for (String cat in categories) {
        if (cat.split("***")[0].trim() == categ) {
          categories.remove(cat);
          break;
        }
      }
    } else {
      for (String cat in categories) {
        if (cat.split("***")[0].trim() == categ) {
          print("found again");

          categories.remove(cat);
          break;
        }
      }

      categories.add(value);
    }
    print(categories);
  }
}

class CategoryItem extends StatefulWidget {
  final String categoryName;
  final Function selectCategory;
  const CategoryItem(
      {required this.categoryName, required this.selectCategory});
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
            onTap: categorySelected,
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

                        widget.selectCategory(
                            "${widget.categoryName} *** $responseText");
                        categorySelected();
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

                        widget.selectCategory(
                            "${widget.categoryName} *** $responseText");
                        categorySelected();
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

                        widget.selectCategory(
                            "${widget.categoryName} *** $responseText");
                        categorySelected();
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

                        widget.selectCategory(
                            "${widget.categoryName} *** $responseText");
                        categorySelected();
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

                        widget.selectCategory(
                            "${widget.categoryName} *** $responseText");
                        categorySelected();
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

                        widget.selectCategory(
                            "${widget.categoryName} *** $responseText");
                        categorySelected();
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

                        widget.selectCategory(
                            "${widget.categoryName} *** $responseText");
                        categorySelected();
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

  void categorySelected() {
    {
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
    ;
  }
}
