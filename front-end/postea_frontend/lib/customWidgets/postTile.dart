import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postea_frontend/customWidgets/topic_pill.dart';
import '../colors.dart';
import './expandedPostTile.dart';
import 'package:postea_frontend/customWidgets/expandedPostTile.dart';
import '../pages/profile.dart';
import 'package:badges/badges.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  var isExpanded;

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
      this.myPID,
      this.isExpanded);

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
      this.myPID,
      this.isExpanded);
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
  var comment;
  var name;
  var myPID;
  var like_count;
  var dislike_count;
  var isExpanded;

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
      this.myPID,
      this.isExpanded);

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
    int post_likes = int.parse(widget.post_likes);
    int post_dislikes = int.parse(widget.post_dislikes);
    int post_comments = int.parse(widget.post_comments);

    // print("post likes = " + widget.post_likes);

    bool showLikeBadge = post_likes > 0;
    bool showDislikeBadge = post_dislikes > 0;
    bool showCommentsBadge = post_comments > 0;
    var profilePicName = name == "Anonymous" ? "default-big.png" : profile_id.toString();
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    return Card(
        shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.only(top: 8, left: 12, right: 12),
        clipBehavior: Clip.antiAlias,
        child: Column(
    children: [
      ListTile(
        trailing: TopicPill(
          topicId: topic_id,
          // col1: Colors.purple[900],
          // col2: Colors.purple[400],
          col1: Theme.of(context).primaryColorLight,
          col2: Theme.of(context).primaryColorDark,
          height: screenheight/20,
          width: screenwidth/4,
          profileId: myPID,
          isOwner: false,
        ),
        onTap: () => {
          if (myPID != widget.profile_id)
            {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => Profile(
                        profileId: int.parse(profile_id),
                        isOwner: false,
                      )))
            }
          else
            {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => Profile(
                        profileId: int.parse(profile_id),
                        isOwner: true,
                      )))
            },
        },
        leading: FutureBuilder(
          future: FirebaseStorageService.getImage(context, profilePicName),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data),
            backgroundColor: Colors.deepPurpleAccent[50],
          );
            }
            else{
              return CircularProgressIndicator(
                                        strokeWidth: 2,
                                        backgroundColor: bgColor,
                                        valueColor: AlwaysStoppedAnimation(
                                            loginButtonEnd),
                                      );
            } 
          },
        ),
        title: Text(
          profile_id != -1?name:"Anonymous",
          style: Theme.of(context).textTheme.headline1,
        ),
        // subtitle: Row(
        //   children: [
        //     Icon(
        //       Icons.location_on,
        //       size: 15,
        //       color: Colors.grey,
        //     ),
        //     Text("with Darshil Kaneria",style: TextStyle(fontSize: 12),)
        //   ],
        // ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(width: 0.5, color: Colors.grey),
        )),
        child: ListTile(
            onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExpandedPostTile(
                              post_id,
                              profile_id,
                              post_description,
                              topic_id,
                              post_img,
                              creation_date,
                              post_likes.toString(),
                              post_dislikes.toString(),
                              post_comments.toString(),
                              post_title,
                              name,
                              myPID)))
                },
            contentPadding:
                EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            title: Text(post_title,
                style:
                    Theme.of(context).textTheme.headline2),
            subtitle: AutoSizeText(
              post_description,
              style: Theme.of(context).textTheme.headline3,
            )),
      ),
      Container(
        child:  
        FutureBuilder(
          future: FirebaseStorageService.getImagePost(context, post_id.toString()),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return isExpanded == 1 ? Image.network(
                snapshot.data,
                width: screenwidth,
                fit: BoxFit.fitWidth,
                loadingBuilder: (context, child, loadingProgress) {
                  return loadingProgress == null ? child : LinearProgressIndicator();
                },
                ) : ClipRect(
                  child: Container(
                    child: Align(
                      heightFactor: 0.3,
                      widthFactor: 1.0,
                      child: Image.network(
                snapshot.data,
                width: screenwidth,
                fit: BoxFit.fitWidth,
                loadingBuilder: (context, child, loadingProgress) {
                  return loadingProgress == null ? child : LinearProgressIndicator();
                },
                ),
                    ),
                  ),
                );
            }
            else return Container();
          },
        )
      ),
      Row(
        children: [
          Column(
            children: [
              Badge(
                badgeColor: Colors.deepOrange[100],
                showBadge: showLikeBadge,
                animationType: BadgeAnimationType.fade,
                position: BadgePosition.topEnd(top: 1, end: 1),
                badgeContent: Text(post_likes.toString(), style: TextStyle(fontSize: 10),),
                child: IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    color: Theme.of(context).buttonColor,
                  ),
                  iconSize: 16,
                  onPressed: () {
                    like_or_dislike = "1";
                    setState(() {
                      if (dislike_color == Colors.deepOrange[200]) {
                        dislike_color = Colors.black;
                        post_likes++;
                        post_dislikes--;
                      }
                      if (like_color == Colors.deepOrange[200]) {
                        like_color = Colors.black;
                        post_likes--;
                      } else {
                        like_color = Colors.deepOrange[200];
                        post_likes++;
                      }
                    });
                    print(post_id);
                    print(profile_id);
                    print(like_or_dislike);
                    print(comment);
                    var data = {
                      "engagement_post_id": post_id,
                      "engagement_profile_id": myPID,
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
              ),
            ],
          ),
          Badge(
            badgeContent: Container(child: Text(post_dislikes.toString(), style: TextStyle(fontSize: 10),)),
            badgeColor: Colors.deepOrange[100],
            position: BadgePosition.topEnd(top: 1, end: 1),
            animationType: BadgeAnimationType.fade,
            showBadge: showDislikeBadge,
            child: IconButton(
              icon: Icon(
                Icons.thumb_down,
                color: Theme.of(context).buttonColor,
              ),
              iconSize: 16,
              onPressed: () {
                setState(() {
                  like_or_dislike = "0";
                  if (like_color == Colors.deepOrange[200]) {
                    like_color = Colors.black;
                    post_likes--;
                    post_dislikes++;
                  }
                  if (dislike_color == Colors.deepOrange[200]) {
                    dislike_color = Colors.black;
                    post_dislikes--;
                  } else
                    dislike_color = Colors.deepOrange[200];
                  post_dislikes++;
                });

                var data = {
                  "engagement_post_id": post_id,
                  "engagement_profile_id": myPID,
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
          ),
          Badge(
            showBadge: showCommentsBadge,
            badgeColor: Colors.deepOrange[100],
            position: BadgePosition.topEnd(top: 1, end: 1),
            badgeContent: Text(post_comments.toString(), style: TextStyle(fontSize: 10),),
            animationType: BadgeAnimationType.fade,
            child: IconButton(
              icon: Icon(Icons.comment, color: Theme.of(context).buttonColor,),
              iconSize: 16,
              onPressed: () {},
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 15),
              alignment: Alignment.centerRight,
              child: Text(
                creation_date,
                style: TextStyle(color: Colors.grey, fontSize: 13),
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

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();
  static Future<dynamic> getImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(image)
        .getDownloadURL();
  }
  static Future<dynamic> getImagePost(BuildContext context, String image) async {
    return await FirebaseStorage.instance
        .ref()
        .child("post")
        .child(image)
        .getDownloadURL();
  }
}

