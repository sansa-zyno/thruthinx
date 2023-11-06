import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:truthinx/Models/modelDataModel.dart';
import 'package:truthinx/screens/ModelVerificationScreens/screen6.dart';

class Screen5 extends StatelessWidget {
  ModelDataModel modelData;
  Screen5(this.modelData);

  List<String> personality = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personality"),
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
                      categoryName: "Outgoing",
                      addPersonality: selectPersonality,
                    ),
                    CategoryItem(
                      categoryName: "Opinionated",
                      addPersonality: selectPersonality,
                    ),
                    CategoryItem(
                      categoryName: "Friendly",
                      addPersonality: selectPersonality,
                    ),
                    CategoryItem(
                      categoryName: "Easygoing",
                      addPersonality: selectPersonality,
                    ),
                    CategoryItem(
                      categoryName: "Cheerful",
                      addPersonality: selectPersonality,
                    ),
                    CategoryItem(
                      categoryName: "Articulate",
                      addPersonality: selectPersonality,
                    ),
                    CategoryItem(
                      categoryName: "Approachable",
                      addPersonality: selectPersonality,
                    ),
                    CategoryItem(
                      categoryName: "Adaptable",
                      addPersonality: selectPersonality,
                    ),

                    CategoryItem(
                      categoryName: "Quiet",
                      addPersonality: selectPersonality,
                    ),
                    CategoryItem(
                      categoryName: "Conservative",
                      addPersonality: selectPersonality,
                    ),
                    CategoryItem(
                      categoryName: "Teachable",
                      addPersonality: selectPersonality,
                    ),

                    // CategoryItem(categoryName: ""),
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
                        "Select 1 or more personality attributes that best describe you",
                        textScaleFactor: 1.4,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      /*shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),*/
                      onPressed: () {
                        print(personality.length);
                        if (personality.isNotEmpty) {
                          modelData.personality = personality;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Screen6(modelData)),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Please select atleast 1 Personality attribute");
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

  selectPersonality(String value) {
    if (personality.contains(value)) {
      personality.remove(value);
    } else {
      personality.add(value);
    }
    print(personality);
  }
}

class CategoryItem extends StatefulWidget {
  final String categoryName;
  final addPersonality;
  const CategoryItem(
      {required this.categoryName, required this.addPersonality});
  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool isMark = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isMark = !isMark;
              });
              widget.addPersonality(widget.categoryName);
            },
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
                    style: TextStyle(
                        fontWeight: isMark ? FontWeight.w600 : FontWeight.w300),
                  ),
                  if (isMark)
                    Icon(
                      Icons.check_rounded,
                      color: Colors.orange,
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
