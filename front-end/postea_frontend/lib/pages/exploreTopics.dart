import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';
import 'package:postea_frontend/customWidgets/postTile.dart';
import 'package:postea_frontend/customWidgets/topicCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data_models/process_topic.dart';
import 'package:http/http.dart' as http;

class ExploreTopics extends StatefulWidget {
  @override
  _ExploreTopicsState createState() => _ExploreTopicsState();
}

class _ExploreTopicsState extends State<ExploreTopics> {
  ProcessTopic topic;
  var postInfo;
  SharedPreferences sharedPreferences;

  getAllPostsWithEngagements() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var url =
        "http://postea-server.herokuapp.com/getAllPostsWithEngagement?profile_id=79341";

    http.Response response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer posteaadmin",
      },
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    

    return Scaffold(
      appBar: new AppBar(
        title: Text("Explore Topics", style: Theme.of(context).textTheme.headline1,),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        backgroundColor: Colors.transparent,
        elevation: 0,
        ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight / 1.15,
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    scrollDirection: Axis.horizontal,
                    children: [
                      TopicCard(topicId: 2, height: screenHeight / 2, width: screenWidth / 2, gradient: false,),
                      TopicCard(topicId: 2, height: screenHeight / 2, width: screenWidth / 2, gradient: false,),
                      TopicCard(topicId: 2, height: screenHeight / 2, width: screenWidth / 2, gradient: false,),
                      TopicCard(topicId: 2, height: screenHeight / 2, width: screenWidth / 2, gradient: false,),
                      TopicCard(topicId: 2, height: screenHeight / 2, width: screenWidth / 2, gradient: false,),
                      TopicCard(topicId: 2, height: screenHeight / 2, width: screenWidth / 2, gradient: false,),
                      TopicCard(topicId: 2, height: screenHeight / 2, width: screenWidth / 2, gradient: false,),
                      TopicCard(topicId: 2, height: screenHeight / 2, width: screenWidth / 2, gradient: false,),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    margin: EdgeInsets.only(top: 15, left: 10),
                    child: Column(
                      children: [
                        Container(
                          child: Text("Top Posts...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.headline3.color),),
                        ),
                        Container(
                          child: FutureBuilder(
                            future: getAllPostsWithEngagements(), 
                            builder: (context, snapshot) {
                              var firstPost = json.decode(snapshot.data.body)[0];
                              if (snapshot.hasData) {
                                return PostTile(
                                  firstPost['post_id'].toString(),
                                  firstPost['profile_id'].toString(),
                                  firstPost['post_description'].toString(),
                                  firstPost['topic_id'].toString(),
                                  firstPost['post_img'].toString(),
                                  firstPost['creation_date'].toString(),
                                  firstPost['post_likes'].toString(),
                                  firstPost['post_dislikes'].toString(),
                                  firstPost['post_comments'].toString(),
                                  firstPost['post_title'].toString(),
                                  "Vidit",
                                  "79341",
                                  false,
                                  firstPost['is_sensitive'].toString(),
                                  false
                                );
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(bgGradEnd),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }
                          ),
                        )
                      ]
                    )
                  )
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}