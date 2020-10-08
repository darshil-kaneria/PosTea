import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  PostTile(this.post_id, this.profile_id, this.post_description, this.topic_id, this.post_img, this.creation_date, this.post_likes, this.post_dislikes, this.post_comments, this.post_title);
  


  
  @override
  _PostTileState createState() => _PostTileState(this.post_id, this.profile_id, this.post_description, this.topic_id, this.post_img, this.creation_date, this.post_likes, this.post_dislikes, this.post_comments, this.post_title);
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

  Color like_color = Colors.black;
  Color dislike_color = Colors.black;

  _PostTileState(this.post_id, this.profile_id, this.post_description, this.topic_id, this.post_img, this.creation_date, this.post_likes, this.post_dislikes, this.post_comments, this.post_title);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(top: 10, left: 12, right: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage("https://picsum.photos/200"), backgroundColor: Colors.deepPurpleAccent[50],),
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 0.5, color: Colors.grey),)
            ),
            child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                title: Text(
                    post_title,
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                subtitle: AutoSizeText(
                  post_description,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                )),
          ),
          Row(
            children: [
              IconButton(icon: Icon(Icons.thumb_up, color: like_color,), iconSize: 20, onPressed: (){

                like_or_dislike = "1";
                setState(() {
                  if(dislike_color == Colors.deepOrange[200]){
                    dislike_color = Colors.black;
                  }
                  if(like_color == Colors.deepOrange[200]){
                    like_color = Colors.black;
                  }
                  else
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
                  'http://postea-server.herokuapp.com/addEngagement',
                  headers: {
                  'Content-Type': 'application/json'
                  },
                  body: sendAnswer
                );
              },),
              IconButton(icon: Icon(Icons.thumb_down, color: dislike_color,), iconSize: 20, onPressed: (){
                setState(() {

                  like_or_dislike = "0";
                  if(like_color == Colors.deepOrange[200]){
                    like_color = Colors.black;
                  }
                  if(dislike_color == Colors.deepOrange[200]){
                    dislike_color = Colors.black;
                  }
                  else
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
                  'http://postea-server.herokuapp.com/addEngagement',
                  headers: {
                  'Content-Type': 'application/json'
                  },
                  body: sendAnswer
                );
              },),
              IconButton(icon: Icon(Icons.comment), iconSize: 20, onPressed: (){},),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 15),
                  alignment: Alignment.centerRight,
                  child: Text("3 hours ago", style: TextStyle(color: Colors.grey),),
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}