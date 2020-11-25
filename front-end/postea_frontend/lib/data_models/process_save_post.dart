import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class ProcessSavePost {
  String post_title;
  String post_description;
  String post_id;
  String topic_id;
  String post_img;
  String profile_id;
  String creation_date;
  String post_likes;
  String post_dislikes;
  String post_comments;
  String name;

  ProcessSavePost(
      {this.post_title,
      this.post_description,
      this.post_id,
      this.profile_id,
      this.topic_id,
      this.creation_date,
      this.name,
      this.post_comments,
      this.post_dislikes,
      this.post_img,
      this.post_likes});

  savePost() async {
    final directory = (await getApplicationDocumentsDirectory()).path;

    bool isExists = await io.File('$directory/savedPosts.json').exists();
    int flag = 0;

    if (!isExists) {
      new File(
              '${(await getApplicationDocumentsDirectory()).path}/savedPosts.json')
          .createSync(recursive: true);
      flag = 1;
    }

    final file = File('$directory/savedPosts.json');
    post_title = post_title.replaceAll('\n', "\\n");
    post_description = post_description.replaceAll('\n', '\\n');

    var postInfo = {
      "\"title\"": "\"" + post_title + "\"",
      "\"description\"": "\"" + post_description + "\"",
      "\"post_id\"": post_id,
      "\"profile_id\"": profile_id,
      "\"topic_id\"": topic_id,
      "\"creation_date\"": "\"" + creation_date + "\"",
      "\"name\"": "\"" + name + "\"",
      "\"post_comments\"": post_comments,
      "\"post_dislikes\"": post_dislikes,
      "\"post_img\"": "\"" + post_img + "\"",
      "\"post_likes\"": post_likes
    };
    String postInfoString;

    if (flag == 0) {
      var data = await retrievePost();

      var existingDataString = data.toString();
      existingDataString =
          existingDataString.substring(0, existingDataString.length - 1);

      postInfoString = json.encode(existingDataString +
          ", " +
          json.decode(json.encode(postInfo)).toString() +
          "]");

      print("existing data string: " + existingDataString + "\n\n\n");
      print("encoded existing data string is " +
          json.encode(existingDataString) +
          "\n\n\n");
      print("encoded string is " + json.encode(postInfo).toString() + "\n\n\n");

      print("decoded after encoding: " +
          json.decode(json.encode(postInfo)).toString());
    } else {
      postInfoString = "[ " + json.encode(postInfo) + " ]";
    }

    file.writeAsString(postInfoString);
    print("POST DOWNLOADED SUCCESSFULLY!");
  }

  retrievePost() async {
    try {
      final directory = (await getApplicationDocumentsDirectory()).path;

      final file = File('$directory/savedPosts.json');

      String postInfo = await file.readAsString();

      var postInfoJson = json.decode(postInfo);

      return postInfoJson;
    } catch (e) {
      print("e is " + e.toString());
    }
  }
}
