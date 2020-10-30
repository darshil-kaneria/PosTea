import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
      this.post_title);

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
      this.post_title);
}

class _ExpandedPostTileState extends State<ExpandedPostTile> {
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
  List<String> comments = [];

  Color like_color = Colors.black;
  Color dislike_color = Colors.black;

  Future<http.Response> engagementInfo() async {
    http.Response resp;
    var url = "http://postea-server.herokuapp.com/engagement?post_id=13739";
    resp = await http.get(url);
    // print(resp.body);
    return resp;
  }

  // commentsInfo() async {
  //   Comments comments = new Comments(post_id);
  //   await comments.getComments();
  //   print("please print comments");
  //   print(comments.comments);
  // }

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
      this.post_title);

  @override
  Widget build(BuildContext context) {
    engagementInfo();

    // commentsInfo();

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: new AppBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage("https://picsum.photos/200"),
                          backgroundColor: Colors.deepPurpleAccent[50],
                        ),
                        title: Text(
                          post_id.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 15,
                              color: Colors.grey,
                            ),
                            Text("with Darshil Kaneria")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 0.5, color: Colors.grey),
                    )),
                    child: Card(
                      child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          title: Text(post_title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: AutoSizeText(
                            post_description,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.thumb_up,
                          color: like_color,
                        ),
                        iconSize: 20,
                        onPressed: () {
                          like_or_dislike = "1";
                          setState(() {
                            if (dislike_color == Colors.deepOrange[200]) {
                              dislike_color = Colors.black;
                            }
                            if (like_color == Colors.deepOrange[200]) {
                              like_color = Colors.black;
                            } else
                              like_color = Colors.deepOrange[200];
                          });
                          print(post_id);
                          print(profile_id);
                          print(like_or_dislike);
                          print(comment);
                          var data = {
                            "engagement_post_id": post_id,
                            "engagement_profile_id": profile_id,
                            "like_dislike": like_or_dislike,
                            "comment": comment
                          };
                          var sendAnswer = JsonEncoder().convert(data);
                          print(sendAnswer);
                          Future<http.Response> resp = http.post(
                              'http://postea-server.herokuapp.com/engagement',
                              headers: {'Content-Type': 'application/json'},
                              body: sendAnswer);
                        },
                      ),
                      Text("15k",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15))
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.thumb_down,
                          color: dislike_color,
                        ),
                        iconSize: 20,
                        onPressed: () {
                          setState(() {
                            like_or_dislike = "0";
                            if (like_color == Colors.deepOrange[200]) {
                              like_color = Colors.black;
                            }
                            if (dislike_color == Colors.deepOrange[200]) {
                              dislike_color = Colors.black;
                            } else
                              dislike_color = Colors.deepOrange[200];
                          });

                          var data = {
                            "engagement_post_id": post_id,
                            "engagement_profile_id": profile_id,
                            "like_dislike": like_or_dislike,
                            "comment": comment
                          };
                          var sendAnswer = JsonEncoder().convert(data);
                          Future<http.Response> resp = http.post(
                              'http://postea-server.herokuapp.com/engagement',
                              headers: {'Content-Type': 'application/json'},
                              body: sendAnswer);
                        },
                      ),
                      Text(
                        "100",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )
                    ],
                  ),
                  IconButton(
                    alignment: Alignment.topCenter,
                    icon: Icon(Icons.comment),
                    iconSize: 20,
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 15),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "3 hours ago",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Card(
                  margin: EdgeInsets.only(top: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  // child: ListView.builder(
                  //     physics: BouncingScrollPhysics(),
                  //     itemCount: 5,
                  //     shrinkWrap: true,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       print("comment is " + comments[index]);
                  //       return ListTile(
                  //         title: Text("comments[index]"),
                  //       );
                  //     }),

                  child: FutureBuilder(
                    future: engagementInfo(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        print("response");
                        var engagements = jsonDecode(snapshot.data.body);
                        print(engagements[0]['comment']);

                        for (int i = 0; i < engagements.length; i++) {
                          comments.add(engagements[i]['comment'].toString());
                        }
                        return ListView.builder(
                            itemCount: comments.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              print('in list view builder');
                              print(comments.elementAt(index));
                              return Comments(
                                  comments.elementAt(index), "Vidit Shah");
                            });
                      } else {
                        return Container();
                      }
                    },
                  )

                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Container(
                  //       child: Comments("Today is a lovely day!", "Vidit Shah"),
                  //     ),
                  //     Divider(
                  //       color: Colors.grey,
                  //       indent: 20,
                  //       endIndent: 20,
                  //     ),
                  //     Container(
                  //       child: Comments(
                  //           "I am grateful for everything that I have!",
                  //           "Darshil Kaneria"),
                  //       width: screenWidth,
                  //     ),
                  //     Divider(
                  //       color: Colors.grey,
                  //       indent: 20,
                  //       endIndent: 20,
                  //     ),
                  //     Container(
                  //       child: Comments(
                  //           "This is a very beautiful day! I am loving it...",
                  //           "Bharat Iyer"),
                  //       width: screenWidth,
                  //     ),
                  //     Divider(
                  //       color: Colors.grey,
                  //       indent: 20,
                  //       endIndent: 20,
                  //     ),
                  //     Container(
                  //       child: Comments(
                  //           "You have given me the best gift of my life!\nThank you very much",
                  //           "Vaibbavi SK"),
                  //     ),
                  //     Divider(
                  //       color: Colors.grey,
                  //       indent: 20,
                  //       endIndent: 20,
                  //     ),
                  //     Container(
                  //       child: Comments(
                  //           "Wishing you a very happy birthday!\nMay you succeed in all your endeavors!\nRock this day and the days to come!!",
                  //           "Pooja Bhasker"),
                  //     ),
                  //     Divider(
                  //       color: Colors.grey,
                  //       indent: 20,
                  //       endIndent: 20,
                  //     ),
                  //   ],
                  // ),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
