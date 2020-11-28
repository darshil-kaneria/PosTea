import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:postea_frontend/colors.dart';
import 'package:postea_frontend/customWidgets/postTile.dart';
import 'package:postea_frontend/pages/followingList.dart';
import 'package:postea_frontend/pages/profile.dart';
import './comments.dart';
import 'package:postea_frontend/colors.dart';
import 'package:http/http.dart' as http;

class ExpandedPostTile extends StatefulWidget {
  var post_id;
  var profile_id;
  var post_description;
  var topic_id;
  var post_img;
  var creation_date;
  var post_likes;
  var post_dislikes;
  var post_comments;
  var post_title;
  var name;
  var myPID;

  List<String> comments;

  ExpandedPostTile(
      this.post_id,
      this.profile_id,
      this.post_description,
      this.topic_id,
      this.post_img,
      this.creation_date,
      this.post_likes,
      this.post_dislikes,
      this.post_comments,
      this.post_title,
      this.name,
      this.myPID);

  @override
  _ExpandedPostTileState createState() => _ExpandedPostTileState(
      this.post_id,
      this.profile_id,
      this.post_description,
      this.topic_id,
      this.post_img,
      this.creation_date,
      this.post_likes,
      this.post_dislikes,
      this.post_comments,
      this.post_title,
      this.name,
      this.myPID);
}

class _ExpandedPostTileState extends State<ExpandedPostTile>
    with TickerProviderStateMixin {
  var post_id;
  var profile_id;
  var post_description;
  var topic_id;
  var post_img;
  var creation_date;
  var post_likes;
  var post_dislikes;
  var post_comments;
  var post_title;
  var like_or_dislike = "NULL";
  var comment = "";
  var name;
  var myPID;
  var num_likes;
  var num_dislikes;
  PageController pg = PageController();
  List<String> comments = [];
  ValueNotifier<String> comment_string = ValueNotifier<String>("Add comment");
  ValueNotifier<bool> showNameSuggestions = new ValueNotifier(false);
  var checkCommVal = false;
  Color like_color = Colors.black;
  Color dislike_color = Colors.black;

  Future<http.Response> engagementInfo() async {
    comments = [];
    http.Response resp;
    var url = "http://postea-server.herokuapp.com/engagement?post_id=" +
        post_id.toString();
    resp = await http.get(url);
    return resp;
  }

  getFollowingList() async {
    print("hello before taking following data list");
    http.Response resp = await http.get(
      "http://postea-server.herokuapp.com/followdata?profile_id=" +
          widget.profile_id.toString() +
          "&flag=following_list",
    );
    print("following list is " + json.decode(resp.body).toString());

    var followingData = json.decode(resp.body);

    print("hello before taking topic list");
    http.Response response = await http.get(
        "http://postea-server.herokuapp.com/getFollowingTopics?profile_id=" +
            widget.profile_id.toString());
    print("topic following list is " + json.decode(resp.body).toString());

    var topicFollowData = json.decode(response.body);

    var finalFollowData = [];
    for (var i = 0; i < followingData.length; i++) {
      finalFollowData.add(followingData[i]);
    }

    for (var i = 0; i < topicFollowData.length; i++) {
      finalFollowData.add(topicFollowData[i]);
    }

    print("final follow data is " + finalFollowData.toString());

    return finalFollowData;
  }

  Future<http.Response> getComments() async {
    comments = [];
    var url = "http://postea-server.herokuapp.com/getcomments?post_id=" +
        post_id.toString();

    http.Response response = await http.get(url);
    return response;
  }

  var commentController = TextEditingController();
  _ExpandedPostTileState(
      this.post_id,
      this.profile_id,
      this.post_description,
      this.topic_id,
      this.post_img,
      this.creation_date,
      this.post_likes,
      this.post_dislikes,
      this.post_comments,
      this.post_title,
      this.name,
      this.myPID);

  @override
  Widget build(BuildContext context) {
    // engagementInfo();

    // commentsInfo();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final slideController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    final slideAnimation =
        Tween(begin: Offset(0, 0), end: Offset(1, 0)).animate(slideController);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (checkCommVal == true) comment_string.value = "Edit Comment";
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).buttonColor),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: barrier,
          icon: Icon(Icons.add),
          label: ValueListenableBuilder(
            valueListenable: comment_string,
            builder: (_, value, __) => Text(
              value.toString(),
              style: TextStyle(fontSize: 15),
            ),
          ),
          onPressed: () async {
            if (pg.page == 0.0) {
              pg.animateToPage(1,
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInQuad);
              if (checkCommVal == true) comment_string.value = "Edit Comment";
            } else {
              var reqBody = {
                "engagement_post_id": post_id,
                "engagement_profile_id": myPID,
                "like_dislike": null,
                "comment":
                    commentController.text == "" ? null : commentController.text
              };

              var reqBodyJson = jsonEncode(reqBody);
              http
                  .post("http://postea-server.herokuapp.com/engagement",
                      headers: {"Content-Type": "application/json"},
                      body: reqBodyJson)
                  .then((value) => print(value.body));
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        color: Theme.of(context).canvasColor,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SlideTransition(
              position: slideAnimation,
              child: PostTile(
                  post_id,
                  profile_id,
                  post_description,
                  topic_id,
                  post_img,
                  creation_date,
                  post_likes,
                  post_dislikes,
                  post_comments,
                  post_title,
                  name,
                  myPID,
                  1),
            ),
            Container(
              height: screenHeight / 1.5,
              width: screenWidth,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: pg,
                children: [
                  FutureBuilder(
                    future: getComments(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      comments = [];
                      List<Map> commEngagement = [];
                      if (snapshot.hasData &&
                          snapshot.data.body != "Post does not exist") {
                        bool myComm = false;
                        var myCommId = 0;
                        print("response");
                        Map temp = {};
                        var jsonDecodedEng = jsonDecode(snapshot.data.body);
                        var engagements = jsonDecodedEng['message'];
                        for (int i = 0; i < engagements.length; i++) {
                          if (engagements[i]['comment'] == null) {
                            continue;
                          }

                          print(engagements[i]['comment'].toString() != null &&
                              engagements[i]['profile_id'].toString() ==
                                  myPID.toString());
                          if (engagements[i]['comment'].toString() != null) {
                            print("IN HERE");

                            // temp['profile_id'] = engagements[i]['profile_id'];

                            // temp['name'] = engagements[i]['name'];

                            // print("temp is " + temp.toString());
                            print("engagements[i] is " +
                                engagements[i].toString());
                            if (engagements[i]['flag'].contains("Tag exists")) {
                              commEngagement.add(
                                {
                                  "profile_id": engagements[i]['profile_id'],
                                  "name": engagements[i]['name'],
                                  "tag": engagements[i]['tag'],
                                  "tag_id": engagements[i]['tag_id'],
                                  "flag": engagements[i]['flag'],
                                },
                              );
                            } else {
                              commEngagement.add(
                                {
                                  "profile_id": engagements[i]['profile_id'],
                                  "name": engagements[i]['name'],
                                  "tag": null,
                                  "tag_id": null,
                                  "flag": engagements[i]['flag'],
                                },
                              );
                            }

                            print("commEngagement[i] is " +
                                commEngagement.toString());
                            commentController.text = engagements[i]['comment'];
                            // comment_string.value = "Edit comment";
                            checkCommVal = true;
                          }
                          comments.add(engagements[i]['comment'].toString());
                        }

                        if (comments.length == 0 || comments == null) {
                          return Container();
                        }

                        return ListView.builder(
                          itemCount: commEngagement.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            print(commEngagement[index]);
                            print("Now printing comment");
                            print(comments.elementAt(index));
                            if (comments.elementAt(index) == null) {
                              return Container(
                                width: 0,
                                height: 0,
                              );
                            } else {
                              if (commEngagement[index]['flag']
                                  .contains("Tag exists")) {
                                return Comments(
                                  profileID: commEngagement[index]
                                      ['profile_id'],
                                  comment: comments.elementAt(index),
                                  personName:
                                      commEngagement[index]['name'].toString(),
                                  flag:
                                      commEngagement[index]['flag'].toString(),
                                  tag: commEngagement[index]['tag'].toString(),
                                  tagID: commEngagement[index]['tag_id']
                                      .toString(),
                                );
                              } else {
                                return Comments(
                                  profileID: commEngagement[index]
                                      ['profile_id'],
                                  comment: comments.elementAt(index),
                                  personName:
                                      commEngagement[index]['name'].toString(),
                                  flag:
                                      commEngagement[index]['flag'].toString(),
                                );
                              }
                            }
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        TextField(
                          cursorColor: Theme.of(context).accentColor,
                          style: Theme.of(context).textTheme.headline2,
                          controller: commentController,
                          onChanged: (text) {
                            if (text.endsWith("@")) {
                              showNameSuggestions.value = true;
                            } else if (!text.contains("@")) {
                              showNameSuggestions.value = false;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: "Your comment:",
                              labelStyle:
                                  Theme.of(context).textTheme.headline1),
                        ),
                        Container(
                          child: ValueListenableBuilder(
                            valueListenable: showNameSuggestions,
                            builder: (_, value, __) {
                              var followingData = getFollowingList();
                              if (value) {
                                return FutureBuilder(
                                  future: getFollowingList(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var followingData = snapshot.data;
                                      return Container(
                                        width: screenWidth,
                                        height: screenHeight / 2,
                                        child: ListView.builder(
                                          itemCount: followingData.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              onTap: () {
                                                String currComment =
                                                    commentController.text;

                                                int indexOfAt =
                                                    currComment.indexOf("@");

                                                if (followingData[index]
                                                        ['username'] !=
                                                    null) {
                                                  if (indexOfAt ==
                                                      currComment.length - 1) {
                                                    commentController.text =
                                                        commentController.text +
                                                            followingData[index]
                                                                ['username'];
                                                  } else {
                                                    commentController.text =
                                                        commentController
                                                            .text
                                                            .replaceFirst(
                                                                currComment.substring(
                                                                    indexOfAt +
                                                                        1,
                                                                    currComment
                                                                        .length),
                                                                followingData[
                                                                        index][
                                                                    'username']);
                                                  }
                                                } else {
                                                  if (indexOfAt ==
                                                      currComment.length - 1) {
                                                    commentController.text =
                                                        commentController.text +
                                                            followingData[index]
                                                                ['topic_name'];
                                                  } else {
                                                    commentController.text =
                                                        commentController
                                                            .text
                                                            .replaceFirst(
                                                                currComment.substring(
                                                                    indexOfAt +
                                                                        1,
                                                                    currComment
                                                                        .length),
                                                                followingData[
                                                                        index][
                                                                    'topic_name']);
                                                  }
                                                }
                                              },
                                              leading: FutureBuilder(
                                                future: followingData[index]
                                                            ['profile_id'] ==
                                                        null
                                                    ? FirebaseStorageService
                                                        .getImage(
                                                        context,
                                                        followingData[index]
                                                                ['topic_id']
                                                            .toString(),
                                                      )
                                                    : FirebaseStorageService
                                                        .getImage(
                                                        context,
                                                        followingData[index]
                                                                ['profile_id']
                                                            .toString(),
                                                      ),
                                                builder: (context,
                                                    AsyncSnapshot<dynamic>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    return CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              snapshot.data),
                                                      maxRadius:
                                                          screenWidth / 20,
                                                    );
                                                  } else {
                                                    return CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          "https://picsum.photos/250?image=18"),
                                                    );
                                                  }
                                                },
                                              ),
                                              title: followingData[index]
                                                          ['username'] ==
                                                      null
                                                  ? Text(followingData[index]
                                                      ['topic_name'])
                                                  : Text(
                                                      followingData[index]
                                                          ['username'],
                                                    ),
                                              subtitle: followingData[index]
                                                          ['username'] ==
                                                      null
                                                  ? Text("Topic")
                                                  : Text("Profile"),
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation(bgGradEnd),
                                        ),
                                      );
                                    }
                                  },
                                );
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
            // ButtonTheme(
            //   child: RaisedButton(
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20)),
            //     child: ValueListenableBuilder(
            //       valueListenable: comment_string,
            //       builder: (_, value, __) => Text(
            //         value.toString(),
            //         style: TextStyle(fontSize: 15),
            //       ),
            //     ),
            //     onPressed: () async {
            //       var reqBody = {
            //         "engagement_post_id": post_id,
            //         "engagement_profile_id": myPID,
            //         "like_dislike": null,
            //         "comment": commentController.text == "" ? null: commentController.text
            //       };

            //       var reqBodyJson = jsonEncode(reqBody);
            //       http.post(
            //         "http://postea-server.herokuapp.com/engagement",
            //         headers: {"Content-Type": "application/json"},
            //         body: reqBodyJson
            //       ).then((value) => print(value.body));
            //     },
            //   ),
            // )
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
