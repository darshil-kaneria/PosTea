import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/main.dart';
import 'package:http/http.dart' as http;
import 'package:postea_frontend/pages/profile.dart';
import 'package:postea_frontend/pages/topic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';

class Comments extends StatefulWidget {
  String personName;
  String comment;
  String tag;
  String tagID;
  String flag;
  var postID;
  var profileID;

  Comments(
      {this.profileID,
      this.comment,
      this.personName,
      this.tag,
      this.tagID,
      this.flag});

  @override
  _CommentsState createState() => _CommentsState(this.comment, this.personName);
}

class _CommentsState extends State<Comments> {
  String comment;
  String personName;
  var screenWidth;
  SharedPreferences prefs;
  List followingList = [];
  List followingProfileIDs = [];
  ValueNotifier<bool> showList = new ValueNotifier(false);

  _CommentsState(this.comment, this.personName);

  @override
  Widget build(BuildContext context) {
    String tag = "";
    int atIndex;
    String firstHalf = "";
    String secondHalf = "";
    screenWidth = MediaQuery.of(context).size.width;

    if (widget.flag.contains("Tag exists")) {
      atIndex = comment.indexOf("@");
      firstHalf = comment.substring(0, atIndex);
      String tempString = comment.substring(atIndex, comment.length);
      if (comment.lastIndexOf(" ") + 1 == atIndex) {
        tag = tempString;
      } else {
        var spaceIndex = tempString.indexOf(" ");
        secondHalf = comment.substring(atIndex + spaceIndex, comment.length);
        tag = comment.substring(atIndex, atIndex + spaceIndex);
      }
      print("tag is " + tag);
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: FutureBuilder(
                    future: FirebaseStorageService.getImage(
                        context, widget.profileID.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data),
                          backgroundColor: Colors.deepPurpleAccent[50],
                          radius: 15,
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: this.personName == null
                        ? Container()
                        : AutoSizeText(
                            this.personName,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                  ),
                  Container(
                    width: screenWidth / 1.25,
                    child: this.comment == null
                        ? Container()
                        : widget.flag.contains("No tag")
                            ? AutoSizeText(this.comment,
                                style: Theme.of(context).textTheme.headline3)
                            : RichText(
                                text: TextSpan(
                                  text: firstHalf,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: tag,
                                        style:
                                            TextStyle(color: Colors.lightBlue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            if (widget.flag
                                                .contains("profile_id")) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Profile(
                                                    profileId:
                                                        int.parse(widget.tagID),
                                                    isOwner: widget.profileID ==
                                                            int.parse(
                                                                widget.tagID)
                                                        ? true
                                                        : false,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Topic(
                                                    topicId: widget.tagID,
                                                    profileId: widget.profileID,
                                                    isOwner: false,
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                    TextSpan(
                                      text: secondHalf,
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                  )
                  // : AutoSizeText(
                  //     this.comment,
                  //     // "{\"post retrieved\": \"success\"}",
                  //     style: Theme.of(context).textTheme.headline3,
                  //   ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.thumb_up,
                color: Theme.of(context).buttonColor,
                size: 17,
              )
            ],
          ),
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
}
