import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:truthinx/Models/modelDataModel.dart';
import 'package:truthinx/screens/ModelVerificationScreens/screen7.dart';

class Screen6 extends StatelessWidget {
  ModelDataModel modelData;
  Screen6(this.modelData);
  List<String> attributes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Physical Attributes"),
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
                        categoryName: "Acne", addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Artifical nails",
                        addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Athletic",
                        addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Beard", addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Body Scar",
                        addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Botox/Dysport",
                        addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Cellulite",
                        addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Clean Shaven",
                        addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Clear Skin",
                        addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Curly/Ethinic Hair",
                        addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Curvey", addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Dry Skin",
                        addAttributes: selectAttribute),
                    CategoryItem(
                        categoryName: "Dark Circles",
                        addAttributes: selectAttribute),
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
                      onPressed: () {
                        print(attributes.length);
                        if (attributes.isNotEmpty) {
                          modelData.attributes = attributes;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Screen7(modelData)),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Please select atleast 1 Physical attribute");
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

  selectAttribute(String value) {
    if (attributes.contains(value)) {
      attributes.remove(value);
    } else {
      attributes.add(value);
    }
    print(attributes);
  }
}

class CategoryItem extends StatefulWidget {
  final String categoryName;
  final Function addAttributes;
  const CategoryItem({required this.categoryName, required this.addAttributes});
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
              widget.addAttributes(widget.categoryName);
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
