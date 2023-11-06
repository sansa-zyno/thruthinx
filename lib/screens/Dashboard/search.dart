import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truthinx/screens/Widgets/Model_Grid_Item.dart';

class Search extends StatefulWidget {
  final bool? isClient;
  Search({Key? key, this.isClient}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final TextEditingController _serachText = new TextEditingController();
  // final StreamController<List<SearchData>> _catStream =
  //     StreamController<List<SearchData>>();

  // void _onSearch(String q) async {
  //   if (q.length < 1) {
  //     _catStream.add([]);
  //     return;
  //   }
  //   try {
  //     final Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //       //'Authorization': Constants.authToken,
  //     };

  //     var res = await http.get(
  //         Uri.parse('${Constants.baseUrl}search?keyword=$q'),
  //         headers: headers);
  //     var decodedData = jsonDecode(res.body);

  //     if (decodedData['status'] == "ERROR") {
  //       _catStream.add([]);
  //       return;
  //     }

  //     SearchModel searchResponse = SearchModel.fromJson(decodedData);

  //     final String status = searchResponse.status;

  //     if (status == "SUCCESS") {
  //       _catStream.add(searchResponse.data);
  //     }
  //   } on SocketException catch (e) {
  //     _catStream.addError(e);
  //   }
  // }

  // @override
  // void initState() {
  //   _catStream.add([]);
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _catStream.close();
  //   super.dispose();
  // }
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * .04),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ],
              ),
              Row(
                children: [Container()],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Container(
              height: 60,
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: _serachText,
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                },
                // onChanged: _onSearch,
                style: TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 1),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: 'Search for a user',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                  suffixIcon: IconButton(
                    iconSize: 20,
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        searchQuery = _serachText.text.trim();
                      });
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("user")
                .orderBy("first_name")
                // .where("verification", isEqualTo: 'submitted')
                .where("role", isEqualTo: 'Model')
                .startAt([searchQuery]).endAt(
                    [searchQuery + '\uf8ff']).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.4),
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    return GridProduct(
                        // img: data['profile_pic'],
                        details: data,
                        isVerified: data['verification'] == "VERIFIED",
                        name: data['first_name'],
                        rating: 5.0,
                        raters: 23,
                        gender: data["gender"],
                        img: data['dp'],
                        isClient: widget.isClient!);
                  },
                );
              } else {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(child: Text('No relevant Data found!'));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
