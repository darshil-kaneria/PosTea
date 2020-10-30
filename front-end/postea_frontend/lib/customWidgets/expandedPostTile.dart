import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
  var name;
  var myPID;

  Color like_color = Colors.black;
  Color dislike_color = Colors.black;

  engagementInfo() async {
    http.Response resp;
    var url = "http://postea-server.herokuapp.com/engagement?post_id=74242";
    resp = await http.get(url);

    print("response");
    print(resp.body);
    return resp.body;
  }

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
    var response = engagementInfo();

    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 2 * MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.only(top: 10, left: 12, right: 12),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      if(myPID != widget.profile_id){
                        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Profile(profileId: int.parse(profile_id), isOwner: false,)));
                      }
                      else{
                        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Profile(profileId: int.parse(profile_id), isOwner: true,)));
                      }
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("https://picsum.photos/200"),
                      backgroundColor: Colors.deepPurpleAccent[50],
                    ),
                  ),
                  title: Text(
                    name,
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(width: 0.5, color: Colors.grey),
                )),
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
              Row(
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
              Card(
                margin: EdgeInsets.only(top: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Comments("Today is a lovely day!", "Vidit Shah"),
                    ),
                    Divider(
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Container(
                      child: Comments(
                          "I am grateful for everything that I have!",
                          "Darshil Kaneria"),
                      width: screenWidth,
                    ),
                    Divider(
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Container(
                      child: Comments(
                          "This is a very beautiful day! I am loving it...",
                          "Bharat Iyer"),
                      width: screenWidth,
                    ),
                    Divider(
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Container(
                      child: Comments(
                          "You have given me the best gift of my life!\nThank you very much",
                          "Vaibbavi SK"),
                    ),
                    Divider(
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Container(
                      child: Comments(
                          "Wishing you a very happy birthday!\nMay you succeed in all your endeavors!\nRock this day and the days to come!!",
                          "Pooja Bhasker"),
                    ),
                    Divider(
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
