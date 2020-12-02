import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';
import 'package:postea_frontend/customWidgets/postTile.dart';
import 'package:postea_frontend/data_models/process_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:postea_frontend/main.dart';
import 'package:postea_frontend/pages/edit_profile.dart';
import 'package:postea_frontend/pages/followingList.dart';
import 'package:postea_frontend/pages/topicFollowingList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data_models/process_save_post.dart';

import 'followerList.dart';

class Profile extends StatefulWidget {
  int profileId;
  bool isOwner;
  var myPID;
  Profile({this.profileId, this.isOwner});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var name = "";
  var bio_data = "";
  bool isPrivate = false;
  Map<String, dynamic> profile;
  List<dynamic> listFollowing;
  SharedPreferences prefs;
  String username;
  bool isAccessibilityOn = false;

  var _nameController = TextEditingController();
  var _biodataController = TextEditingController();
  int itemCount = 0;
  int _value;
  PageController controller = PageController(initialPage: 0);

  ValueNotifier<bool> viewEngagements = new ValueNotifier(false);
  Color toggle = Colors.redAccent[100].withOpacity(0.5);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // displayImage();
    _value = 0;
    getProfile();
    getFollowing();
    getCount();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getAllPostsWithEngagements() async {
    var url =
        "http://postea-server.herokuapp.com/getAllPostsWithEngagement?profile_id=" +
            widget.profileId.toString();

    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  getFollowing() async {
    prefs = await SharedPreferences.getInstance();
    widget.myPID = prefs.getInt('profileID') ?? 0;
    print("MY ID" + widget.profileId.toString());
    http
        .get("http://postea-server.herokuapp.com/followdata?profile_id=" +
            widget.profileId.toString() +
            "&flag=following_list")
        .then((resp) {
      listFollowing = jsonDecode(resp.body);
      print("LIST FOLLOWING" + listFollowing.toString());
      for (int i = 0; i < listFollowing.length; i++) {
        // print()
        if (listFollowing[i]['follower_id'] == widget.profileId) {
          isFollow = true;
          buttonColor = Colors.redAccent[100];
          isFollow = true;
          followButtonText = "Following";
          setState(() {});
        }
      }
    });
  }

  updateProfile() async {
    var sendAnswer = JsonEncoder().convert({
      "original_username": username,
      "update_privateAcc": isPrivate.toString(),
      "update_name": name,
      "update_biodata": bio_data,
      "update_profilePic": "random"
    });

    http.Response resp = await http.post(
        "http://postea-server.herokuapp.com/profile",
        headers: {'Content-Type': 'application/json'},
        body: sendAnswer);
    print(resp.body);
    if (resp.statusCode == 200)
      print("success");
    else
      print("Some error");
  }

  getProfile() async {
    prefs = await SharedPreferences.getInstance();
    isAccessibilityOn = prefs.getInt("accessibility") == 1;
    username = prefs.getString('username') ?? "";
    var queryString;
    if (widget.isOwner) {
      // print("HERE");
      queryString = "http://postea-server.herokuapp.com/profile?username=" +
          username.toString();
    } else {
      // print("Not here");
      queryString = "http://postea-server.herokuapp.com/profile/" +
          widget.profileId.toString();
    }
    print(username);
    http.Response resp = await http.get(queryString);
    profile = jsonDecode(resp.body);
    setState(() {
      _nameController.text = profile["message"]["name"];
      name = _nameController.text;
      _biodataController.text = profile["message"]["biodata"];
      bio_data = _biodataController.text;
      isPrivate =
          profile["message"]["privacy"].toString().toLowerCase() == "yes";
      print("isPrivate is " + isPrivate.toString());
    });
    print(profile["message"]["profile_id"]);
  }

  // displayImage() {
  //   Uint8List pic;
  //   StorageReference profilePic =
  //       FirebaseStorage.instance.ref().child("profile");

  //   var url = profilePic.child("tom_and_jerry.jpeg").getDownloadURL();
  //   print("url: " + url.toString());
  // }
  var isFollow = false;
  var buttonColor = Colors.red[50];
  var followButtonText = "Follow";

  final ValueNotifier<int> followingCountNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> followerCountNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> followingListNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> followerListNotifier = ValueNotifier<int>(0);

  List<String> followingList = [];
  List<String> followerList = [];

  getCount() async {
    http
        .get(
      "http://postea-server.herokuapp.com/followdata?profile_id=" +
          widget.profileId.toString() +
          "&flag=following_count",
    )
        .then((value) {
      var followingCount = jsonDecode(value.body);

      followingCountNotifier.value = followingCount['followingCount'];
      // followingCountNotifier.value
    });
    http
        .get(
      "http://postea-server.herokuapp.com/followdata?profile_id=" +
          widget.profileId.toString() +
          "&flag=follower_count",
    )
        .then((value) {
      var followerCount = jsonDecode(value.body);

      followerCountNotifier.value = followerCount['followerCount'];
      // followingCountNotifier.value
    });
  }

  Future getSavedPosts() async {
    ProcessSavePost processSavePost =
        new ProcessSavePost(profile_id: widget.myPID.toString());

    var postInfo = await processSavePost.retrievePost();

    // print("postInfo is " + postInfo.toString());

    return postInfo;
  }

  Future<http.Response> getUserPosts(int profile_id) async {
    var url = "http://postea-server.herokuapp.com/getAllUserPosts?profile_id=" +
        widget.profileId.toString();

    http.Response resp = await http.get(url);
    print("retrieved posts");
    // print(resp.body);
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    print("profileId is " + widget.profileId.toString());
    print("username is " + username.toString());
    print("isFollow is " + isFollow.toString());
    var followerString = "Topics that " + name.toString() + " follows";
    // displayImage();

    return SafeArea(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: PageView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            Material(
              child: Container(
                width: screenWidth,
                height: screenHeight / 1.1,
                // margin: EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        widget.isOwner
                            ? IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 300),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                              opacity: animation,
                                              child: SlideTransition(
                                                position: Tween<Offset>(
                                                        begin: Offset(0, -1),
                                                        end: Offset(0, 0))
                                                    .animate(CurvedAnimation(
                                                        parent: animation,
                                                        curve:
                                                            Curves.decelerate)),
                                                child: child,
                                              ));
                                        },
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double> secAnimation) {
                                          return EditProfile(
                                              nameText: name,
                                              biodata: bio_data,
                                              privacy: isPrivate,
                                              username: username,
                                              profile_id: widget.myPID);
                                        },
                                      ));
                                },
                              )
                            : Container(),
                      ],
                    ),
                    Container(
                      // height: screenHeight / 4,
                      width: screenWidth,
                      color: Colors.transparent,
                      // padding: EdgeInsets.only(top: screenHeight / 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: screenWidth / 4,
                                  width: screenWidth / 4,
                                  decoration: ShapeDecoration(
                                      shape: CircleBorder(
                                          side: BorderSide(
                                              width: 1,
                                              color: Colors.blueGrey))),
                                  child: FutureBuilder(
                                      future: FirebaseStorageService.getImage(
                                          context, widget.profileId.toString()),
                                      builder: (context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.hasData) {
                                          return CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(snapshot.data),
                                            maxRadius: screenWidth / 8,
                                          );
                                        } else {
                                          return CircularProgressIndicator(
                                            strokeWidth: 2,
                                            backgroundColor: bgColor,
                                            valueColor: AlwaysStoppedAnimation(
                                                loginButtonEnd),
                                          );
                                        }
                                      }),
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        name,
                                        maxFontSize: 29,
                                        minFontSize: 27,
                                        softWrap: true,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom: screenHeight / 40)),
                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: isPrivate &&
                                                          !widget.isOwner &&
                                                          !isFollow
                                                      ? null
                                                      : () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      FollowerList(
                                                                        profileId:
                                                                            widget.profileId,
                                                                        name:
                                                                            name,
                                                                      ))).then(
                                                              (value) =>
                                                                  setState(
                                                                      () {}));
                                                        },
                                                  child: Text(
                                                    "Followers",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                ValueListenableBuilder(
                                                    valueListenable:
                                                        followerCountNotifier,
                                                    builder: (_, value, __) =>
                                                        Text(value.toString()))
                                              ],
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth / 25)),
                                            Container(
                                              // height: 20,
                                              width: 0.5,
                                              color: Colors.blueGrey,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth / 25)),
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: isPrivate &&
                                                          !widget.isOwner &&
                                                          !isFollow
                                                      ? null
                                                      : () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      FollowingList(
                                                                        profileId:
                                                                            widget.profileId,
                                                                        name:
                                                                            name,
                                                                      ))).then(
                                                              (value) =>
                                                                  setState(
                                                                      () {}));
                                                        },
                                                  child: Text(
                                                    "Following",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                ValueListenableBuilder(
                                                    valueListenable:
                                                        followingCountNotifier,
                                                    builder: (_, value, __) =>
                                                        Text(value.toString()))
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ]),
                              ],
                            ),
                          ),
                          // Profile circle
                          SizedBox(
                            height: screenHeight / 25,
                          ),
                          widget.isOwner == false
                              ? Container(
                                  height: screenHeight / 14,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth / 15,
                                      vertical: 10),
                                  child: ButtonTheme(
                                      buttonColor: buttonColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      minWidth: screenWidth / 1.5,
                                      child: RaisedButton(
                                          elevation: 2,
                                          clipBehavior: Clip.antiAlias,
                                          child: Text(followButtonText),
                                          onPressed: () async {
                                            print(isFollow);

                                            if (isFollow) {
                                              buttonColor = Colors.red[50];
                                              isFollow = false;
                                              followButtonText = "Follow";
                                              final request = http.Request(
                                                "DELETE",
                                                Uri.parse(
                                                    "http://postea-server.herokuapp.com/followdata"),
                                              );
                                              request.headers.addAll({
                                                'Content-Type':
                                                    'application/json'
                                              });
                                              request.body = jsonEncode({
                                                "profile_id": widget.myPID,
                                                "follower_id": widget.profileId
                                              });
                                              request.send();
                                            } else {
                                              buttonColor =
                                                  Colors.redAccent[100];
                                              isFollow = true;
                                              followButtonText = "Following";
                                              var addfollowing = {
                                                "profile_id": widget.myPID,
                                                "follower_id": widget.profileId
                                              };
                                              var addfollowingJson =
                                                  JsonEncoder()
                                                      .convert(addfollowing);
                                              http.post(
                                                  "http://postea-server.herokuapp.com/followdata",
                                                  headers: {
                                                    'Content-Type':
                                                        'application/json'
                                                  },
                                                  body: addfollowingJson);
                                            }

                                            setState(() {});
                                          })),
                                )
                              : Container(),

                          // Follow & Following Buttons
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: <Widget>[
                          // Follower button
                          // Stack(
                          //   alignment: Alignment.centerRight,
                          //   children: [
                          //     ButtonTheme(
                          //       padding: EdgeInsets.only(right: 40),
                          //       height: 50,
                          //       minWidth: screenWidth / 2.5,
                          //       child: RaisedButton(
                          //         color: profileButtoColor,
                          //         onPressed: () {},
                          //         child: Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceAround,
                          //             children: [
                          //               // IconButton(
                          //               //     icon: Icon(Icons.add), onPressed: () {}),
                          //               Text("Followers")
                          //             ]),
                          //         elevation: 0,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(100),
                          //             side: BorderSide(color: Colors.transparent)),
                          //       ),
                          //     ),
                          //     ButtonTheme(
                          //       height: 55,
                          //       minWidth: screenWidth / 7,
                          //       child: RaisedButton(
                          //         color: ffDisplayer,
                          //         onPressed: () {},
                          //         child: Text("4.2k"),
                          //         elevation: 6,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.only(
                          //                 topLeft: Radius.zero,
                          //                 bottomLeft: Radius.zero,
                          //                 topRight: Radius.circular(100),
                          //                 bottomRight: Radius.circular(100)),
                          //             side: BorderSide(color: Colors.black12)),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          // Stack(
                          //   alignment: Alignment.centerRight,
                          //   children: [
                          //     ButtonTheme(
                          //       padding: EdgeInsets.only(right: 40),
                          //       height: 50,
                          //       minWidth: screenWidth / 2.6,
                          //       child: RaisedButton(
                          //         color: profileButtoColor,
                          //         onPressed: () {},
                          //         child: Text(
                          //           "Following",
                          //         ),
                          //         elevation: 0,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(100),
                          //             side: BorderSide(color: Colors.transparent)),
                          //       ),
                          //     ),
                          //     ButtonTheme(
                          //       height: 55,
                          //       minWidth: screenWidth / 7,
                          //       child: RaisedButton(
                          //         color: ffDisplayer,
                          //         onPressed: () {},
                          //         child: Text("6.5k"),
                          //         elevation: 6,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.only(
                          //                 topLeft: Radius.zero,
                          //                 bottomLeft: Radius.zero,
                          //                 topRight: Radius.circular(100),
                          //                 bottomRight: Radius.circular(100)),
                          //             side: BorderSide(color: Colors.black12)),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // height: screenHeight / 1.6,
                        width: screenWidth,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 12),
                              child: isPrivate && !widget.isOwner && !isFollow
                                  ? Container()
                                  : Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.red[50],
                                          border: Border.all(
                                              color: Colors.black12)),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                            canvasColor: Colors.red[100],
                                            buttonTheme: ButtonTheme.of(context)
                                                .copyWith(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                width: 1.0,
                                                                style:
                                                                    BorderStyle
                                                                        .solid),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0)),
                                                    alignedDropdown: true)),
                                        child: DropdownButton(
                                            isExpanded: true,
                                            underline: SizedBox(),
                                            icon: null,
                                            value: _value,
                                            items: [
                                              DropdownMenuItem(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0),
                                                  child: Container(
                                                    child: Text("About"),
                                                  ),
                                                ),
                                                value: 0,
                                              ),
                                              DropdownMenuItem(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0),
                                                  child: Container(
                                                    child: Text("Posts"),
                                                  ),
                                                ),
                                                value: 1,
                                              ),
                                              DropdownMenuItem(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0),
                                                  child: Container(
                                                    child: Text("Topics"),
                                                  ),
                                                ),
                                                value: 3,
                                              ),
                                            ],
                                            onChanged: (num value) {
                                              setState(() {
                                                _value = value;
                                              });
                                              controller.animateToPage(_value,
                                                  duration: Duration(
                                                      milliseconds: 150),
                                                  curve: Curves.decelerate);
                                              print(controller.page);
                                            }),
                                      ),
                                    ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                // height: screenHeight / 1.8,
                                color: Colors.transparent,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        margin: EdgeInsets.only(
                                            top: 10, left: 12, right: 12),
                                        elevation: 1,
                                        clipBehavior: Clip.antiAlias,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Container(
                                            child: Text(bio_data),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   height: screenHeight/3,
                    //   width: screenWidth,
                    //   color: Colors.yellowAccent,
                    // ),
                  ],
                ),
              ),
            ),
            Material(
              child: Container(
                width: screenWidth,
                height: screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        controller.animateToPage(0,
                            duration: Duration(milliseconds: 150),
                            curve: Curves.easeIn);
                      },
                    ),
                    Hero(
                      tag: 'dmenu',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 12),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.red[50],
                              border: Border.all(color: Colors.black12)),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                canvasColor: Colors.red[100],
                                buttonTheme: ButtonTheme.of(context)
                                    .copyWith(alignedDropdown: true)),
                            child: DropdownButton(
                                isDense: false,
                                isExpanded: true,
                                underline: SizedBox(),
                                icon: null,
                                value: _value,
                                items: [
                                  DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Container(
                                        child: Text("About"),
                                      ),
                                    ),
                                    value: 0,
                                  ),
                                  DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Container(
                                        child: Text("Posts"),
                                      ),
                                    ),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Container(
                                        child: Text("Topics"),
                                      ),
                                    ),
                                    value: 3,
                                  ),
                                ],
                                onChanged: (num value) {
                                  setState(() {
                                    _value = value;
                                    controller.animateToPage(_value,
                                        duration: Duration(milliseconds: 150),
                                        curve: Curves.decelerate);
                                    print(value);
                                  });
                                  // print(value);
                                }),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: screenWidth,
                        height: screenHeight / 1.4,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: screenWidth / 2,
                                  margin: EdgeInsets.only(left: 15),
                                  child: Row(
                                    children: [
                                      Text("View engagements"),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: ValueListenableBuilder(
                                          valueListenable: viewEngagements,
                                          builder: (context, value, child) {
                                            return AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              height: 20,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: toggle),
                                              child: Stack(
                                                children: [
                                                  AnimatedPositioned(
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (viewEngagements
                                                              .value) {
                                                            toggle = Colors
                                                                .redAccent
                                                                .withOpacity(
                                                                    0.5);
                                                            viewEngagements
                                                                .value = false;
                                                          } else {
                                                            toggle = Colors
                                                                .greenAccent;
                                                            viewEngagements
                                                                .value = true;
                                                          }
                                                          // toggleButton();
                                                        },
                                                        child: AnimatedSwitcher(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  200),
                                                          transitionBuilder:
                                                              (Widget child,
                                                                  Animation<
                                                                          double>
                                                                      animation) {
                                                            return ScaleTransition(
                                                              child: child,
                                                              scale: animation,
                                                            );
                                                          },
                                                          child: value
                                                              ? Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 15,
                                                                  key:
                                                                      UniqueKey(),
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .remove_circle_outline,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 15,
                                                                  key:
                                                                      UniqueKey(),
                                                                ),
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 200),
                                                      curve: Curves.easeIn,
                                                      top: 3,
                                                      left: value ? 30 : 0,
                                                      right: value ? 0 : 30),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: screenWidth / 2.5,
                                  child: widget.isOwner
                                      ? GestureDetector(
                                          child: Text(
                                            "View Saved Posts",
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          onTap: () {
                                            controller.animateToPage(2,
                                                duration:
                                                    Duration(milliseconds: 150),
                                                curve: Curves.decelerate);
                                          },
                                        )
                                      : Container(
                                          width: 0,
                                          height: 0,
                                        ),
                                ),
                              ],
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight / 1.41,
                              margin: EdgeInsets.only(top: 10),
                              child: ValueListenableBuilder(
                                valueListenable: viewEngagements,
                                builder: (context, value, child) {
                                  if (value) {
                                    return FutureBuilder(
                                      future: getAllPostsWithEngagements(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data !=
                                                "No posts made by this user") {
                                          var postData = snapshot.data;
                                          return ListView.builder(
                                            itemCount: postData.length,
                                            itemBuilder: (context, index) {
                                              return PostTile(
                                                  postData[index]['post_id']
                                                      .toString(),
                                                  postData[index]['profile_id']
                                                      .toString(),
                                                  postData[index]
                                                          ['post_description']
                                                      .toString(),
                                                  postData[index]['topic_id']
                                                      .toString(),
                                                  postData[index]['post_img']
                                                      .toString(),
                                                  postData[index]
                                                          ['creation_date']
                                                      .toString(),
                                                  postData[index]['post_likes']
                                                      .toString(),
                                                  postData[index]
                                                          ['post_dislikes']
                                                      .toString(),
                                                  postData[index]
                                                          ['post_comments']
                                                      .toString(),
                                                  postData[index]['post_title']
                                                      .toString(),
                                                  postData[index]['name']
                                                      .toString(),
                                                  profileId.toString(),
                                                  false,
                                                  postData[index]
                                                      ['is_sensitive'],
                                                  isAccessibilityOn);
                                            },
                                          );
                                          // return ListView.builder(
                                          //     itemCount: snapshot.data.length,
                                          //     itemBuilder: (context, index) {});
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      bgGradEnd),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  } else {
                                    return FutureBuilder(
                                      future: getUserPosts(widget.myPID),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data !=
                                                "No posts made by this user") {
                                          http.Response resp = snapshot.data;
                                          var postData = json.decode(resp.body);
                                          return ListView.builder(
                                            itemCount: postData.length,
                                            itemBuilder: (context, index) {
                                              return PostTile(
                                                  postData[index]['post_id']
                                                      .toString(),
                                                  postData[index]['profile_id']
                                                      .toString(),
                                                  postData[index]
                                                          ['post_description']
                                                      .toString(),
                                                  postData[index]['topic_id']
                                                      .toString(),
                                                  postData[index]['post_img']
                                                      .toString(),
                                                  postData[index]
                                                          ['creation_date']
                                                      .toString(),
                                                  postData[index]['post_likes']
                                                      .toString(),
                                                  postData[index]
                                                          ['post_dislikes']
                                                      .toString(),
                                                  postData[index]
                                                          ['post_comments']
                                                      .toString(),
                                                  postData[index]['post_title']
                                                      .toString(),
                                                  name.toString(),
                                                  profileId.toString(),
                                                  false,
                                                  postData[index]
                                                      ['is_sensitive'],
                                                  isAccessibilityOn);
                                            },
                                          );
                                          // return ListView.builder(
                                          //     itemCount: snapshot.data.length,
                                          //     itemBuilder: (context, index) {});
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      bgGradEnd),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              child: Container(
                width: screenWidth,
                height: screenHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        controller.jumpToPage(
                          1,
                        );
                      },
                    ),
                    Container(
                      width: screenWidth,
                      height: screenHeight / 1.15,
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              "Saved Posts",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ),
                          Container(
                            width: screenWidth,
                            height: screenHeight / 1.25,
                            margin: EdgeInsets.only(top: 10),
                            child: FutureBuilder(
                              future: getSavedPosts(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var postInfo = snapshot.data;
                                  var postInfoString = postInfo.toString();
                                  List postMap = json.decode(postInfoString);

                                  return ListView.builder(
                                      itemCount: postMap.length,
                                      itemBuilder: (context, index) {
                                        return PostTile(
                                            postMap[index]['post_id']
                                                .toString(),
                                            postMap[index]['profile_id']
                                                .toString(),
                                            postMap[index]['description']
                                                .toString(),
                                            postMap[index]['topic_id']
                                                .toString(),
                                            postMap[index]['post_img']
                                                .toString(),
                                            postMap[index]['creation_date']
                                                .toString(),
                                            postMap[index]['post_likes']
                                                .toString(),
                                            postMap[index]['post_dislikes']
                                                .toString(),
                                            postMap[index]['post_comments']
                                                .toString(),
                                            postMap[index]['post_title']
                                                .toString(),
                                            name.toString(),
                                            profileId.toString(),
                                            false,
                                            postMap[index]['is_sensitive'],
                                            isAccessibilityOn);
                                      });
                                  // return ListView.builder(
                                  //     itemCount: snapshot.data.length,
                                  //     itemBuilder: (context, index) {});
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                width: screenWidth,
                height: screenHeight,
                child: Material(
                  child: Container(
                    height: screenHeight / 1.1,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                controller.jumpToPage(
                                  0,
                                );
                              },
                            ),
                            Text(
                              followerString,
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                        TopicFollowingList(
                          profileId: widget.profileId.toString(),
                          name: name,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();
  static Future<dynamic> getImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(image)
        .getDownloadURL();
  }
}
