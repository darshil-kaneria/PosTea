import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

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
            leading: Icon(
              Icons.account_circle,
              size: 40,
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
              IconButton(icon: Icon(Icons.thumb_up), iconSize: 20, onPressed: (){},),
              IconButton(icon: Icon(Icons.thumb_down), iconSize: 20, onPressed: (){},),
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
