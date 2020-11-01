import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postea_frontend/customWidgets/topic_pill.dart';
import './expandedPostTile.dart';
import 'package:postea_frontend/customWidgets/expandedPostTile.dart';
import '../pages/profile.dart';

class PostTile extends StatefulWidget {
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

  PostTile(
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
  _PostTileState createState() => _PostTileState(
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

class _PostTileState extends State<PostTile> {
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
  var like_count;
  var dislike_count;

  Color like_color = Colors.black;
  Color dislike_color = Colors.black;

  _PostTileState(
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

  Future<http.Response> getLikesDislikes() async {
    http.Response resp;
    var url = "http://postea-server.herokuapp.com/engagement?post_id=" +
        post_id.toString();
    resp = await http.get(url);
    // print(resp.body);
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(top: 10, left: 12, right: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            trailing: TopicPill(
              topicId: topic_id,
              col1: Colors.purple[900],
              col2: Colors.purple[400],
              height: screenheight/10,
              width: screenwidth/4,
            ),
            leading: GestureDetector(
              onTap: () {
                if (myPID != widget.profile_id) {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => Profile(
                            profileId: int.parse(profile_id),
                            isOwner: false,
                          )));
                } else {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => Profile(
                            profileId: int.parse(profile_id),
                            isOwner: true,
                          )));
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(width: 0.5, color: Colors.grey),
            )),
            child: ListTile(
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Hero(
                                  tag: 'postAnimation',
                                  child: ExpandedPostTile(
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
                                      myPID))))
                    },
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                title: Text(post_title,
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                subtitle: AutoSizeText(
                  post_description,
                  style: TextStyle(fontSize: 15, color: Colors.black),
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
                ],
              ),
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
              IconButton(
                icon: Icon(Icons.comment),
                iconSize: 20,
                onPressed: () {},
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 15),
                  alignment: Alignment.centerRight,
                  child: Text(
                    creation_date,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
