import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';
import 'package:postea_frontend/customWidgets/postTile.dart';
import 'package:postea_frontend/pages/profile.dart';
import './comments.dart';
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
  var is_sensitive;

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
      this.myPID,
      this.is_sensitive);

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
                  1,
                  widget.is_sensitive),
            )
            ,
            Container(
              height: screenHeight / 1.5,
              width: screenWidth,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: pg,
                  children: [
                    FutureBuilder(
                      future: engagementInfo(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        comments = [];
                        List<Map> commEngagement = [];
                        if (snapshot.hasData &&
                            snapshot.data.body != "Post does not exist") {
                          bool myComm = false;
                          var myCommId = 0;
                          print("response");
                          print(snapshot.data.body);
                          Map temp = {};
                          var engagements = jsonDecode(snapshot.data.body);

                          for (int i = 0; i < engagements.length; i++) {
                            if (engagements[i]['comment'] == null) {
                              continue;
                            }

                            print(
                                engagements[i]['comment'].toString() != null &&
                                    engagements[i]['profile_id'].toString() ==
                                        myPID.toString());
                            if (engagements[i]['comment'].toString() != null) {
                              print("IN HERE");

                              temp['profile_id'] = engagements[i]['profile_id'];

                              temp['name'] = name;

                              commEngagement.add(temp);
                              commentController.text =
                                  engagements[i]['comment'];
                              // comment_string.value = "Edit comment";
                              checkCommVal = true;
                            }
                            comments.add(engagements[i]['comment'].toString());
                          }

                          if (comments.length == 0 || comments == null) {
                            return Container();
                          }

                          return ListView.builder(
                            itemCount: comments.length,
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
                                return Comments(
                                  commEngagement[index]['profile_id'],
                                  comments.elementAt(index),
                                  commEngagement[index]['name'],
                                );
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
                      child: TextField(
                        cursorColor: Theme.of(context).accentColor,
                        style: Theme.of(context).textTheme.headline2,
                        controller: commentController,
                        decoration: InputDecoration(
                            labelText: "Your comment:",
                            labelStyle: Theme.of(context).textTheme.headline1),
                      ),
                    )
                  ]),
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
