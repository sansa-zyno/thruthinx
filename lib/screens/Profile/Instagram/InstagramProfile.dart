import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:truthinx/screens/Profile/Instagram/FullImageInstagram.dart';
import 'package:truthinx/screens/Profile/Instagram/InstaProfileWebView.dart';
import 'package:insta_public_api/insta_public_api.dart';

class InstagramProfile extends StatefulWidget {
  final userIntaUsername;

  InstagramProfile(this.userIntaUsername);
  @override
  _InstagramProfileState createState() => _InstagramProfileState();
}

class _InstagramProfileState extends State<InstagramProfile> {
  String? username;
  String? followers;
  String? following;
  String? website;
  String? bio;
  String? profileimage;
  String? totalPosts;

  bool profileFound = false;
  bool errorOccured = false;
  bool isPrivate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.account_circle),
          label: Text("Full Profile"),
          onPressed: () {
            if (!profileFound) {
              Fluttertoast.showToast(
                  msg:
                      "Please check your internet connection or update your Insta username from settings",
                  toastLength: Toast.LENGTH_LONG);
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InstaProfileWebView(
                        "https://www.instagram.com/${widget.userIntaUsername}/")));
          },
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: errorOccured
                  ? Center(
                      child: Container(
                        height: 300,
                        child: Lottie.asset("assets/pageNotFound.json",
                            repeat: true),
                      ),
                    )
                  : Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: profileimage == null
                                ? null
                                : NetworkImage(profileimage!),
                            backgroundColor: Colors.grey[200],
                          ),
                          title: Text(username ?? "..."),
                          subtitle: Text(bio ?? "..."),
                          isThreeLine: true,
                          trailing: Image.asset(
                            "assets/instagram.png",
                            height: 32,
                          ),
                        ),
                        Container(
                          height: 100,
                          child: Column(
                            children: [
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RowItem(
                                    "posts",
                                    totalPosts!,
                                  ),
                                  RowItem("followers", followers!),
                                  RowItem("following", following!),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder(
                              future: getInstaProfileData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<String> userData =
                                      snapshot.data as List<String>;

                                  return GridView.count(
                                    crossAxisCount: 3,
                                    children: userData.map((e) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullImageInstagram(e)));
                                        },
                                        child: Hero(
                                          tag: e,
                                          child: Container(
                                            margin: EdgeInsets.all(2),
                                            child: Image.network(
                                              e,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              }),
                        )
                      ],
                    )),
        ),
      ),
    );
  }

  Future<List<String?>> getInstaProfileData() async {
    List<String?> userData = [];
    print("+++++++++++++++++++++++++++");

    try {
      print("+++++++++++++++++++++++++++");

      final ipa = InstaPublicApi(widget.userIntaUsername);
      print("asdasd");
      final info = await ipa.getBasicInfo();
      List<String?> feedImagesUrls = await ipa.getTimelinePostsImages();

      username = info.fullName; //username

      followers = info.followers.toString(); //number of followers

      following = info.following.toString(); // number of following

      bio = info.bio; // Bio

      profileimage = info.profilePic;

      totalPosts = info.noOfPosts.toString();
      isPrivate = info.isPrivate!;
      // Profile picture URL
      userData.addAll(feedImagesUrls);
      //print(userData);
      print("Feed images:${feedImagesUrls.length}");
      //print(flutterInsta.url);
      setState(() {
        profileFound = username!.isNotEmpty;
      });
    } catch (e) {
      print("+++++++++++++++++++++++++++");

      print("ERROR OCCURED WHILE GETING INSTA DATA");
      print(e.toString());
      setState(() {
        errorOccured = true;
      });
    }
    print("+++++++++++++++++++++++++++");

    return userData;
  }
}

class RowItem extends StatelessWidget {
  final String label;
  final String value;

  RowItem(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value != null ? value.toString() : "..."),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}
