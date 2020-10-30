import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:postea_frontend/main.dart';

class Topic extends StatefulWidget {

  var profileId;
  var isOwner;
  var topicId;
  Topic({this.profileId, this.isOwner, this.topicId});
  @override
  _TopicState createState() => _TopicState();
}



class _TopicState extends State<Topic> {

  var offset = 0;

  // ProcessTopic topic;
  // var topicInfo;

  // getTopicInfo() async {
  //   topic.getTopic().then((value){
  //     topicInfo = jsonDecode(value.body);
  //     print(topicInfo);
  //   });
  // }

  // getTopicContent() async {
  //   await topic.setOffset(offset);
  //   return await topic.getPosts();
  // }

  // @override void initState() {
  //   // TODO: implement initState
  //   topic = new ProcessTopic(profile_id: profileId, topic_id: topicId);
  //   getTopicInfo();
  //   getTopicContent();
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.greenAccent,
                alignment: Alignment.center,
                child: Text("Image Here"),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Topic Name",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ),
            Expanded(
              flex: 1,
              child: Card(
                // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                clipBehavior: Clip.hardEdge,
                elevation: 0,
                child: Container(
                  width: screenWidth,
                  child: SingleChildScrollView(
                    child: Text("Random Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom SamplRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample datae dataRandom Sample dataRandom Sample dataRandom Sample dataRandom Sample data"),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                // color: Colors.limeAccent,
                child: ListView(
                  addRepaintBoundaries: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  children: [
                    Container(height: screenHeight/3, width: screenWidth, color: Colors.grey,),
                    Container(height: screenHeight/3, width: screenWidth, color: Colors.pinkAccent,),
                    Container(height: screenHeight/3, width: screenWidth, color: Colors.orangeAccent,),
                    Container(height: screenHeight/3, width: screenWidth, color: Colors.yellowAccent,),
                    Container(height: screenHeight/3, width: screenWidth, color: Colors.blueAccent,)
                  ],
                ),
              )
            )
          ],
        ),
      ),
      
    );
  }
}