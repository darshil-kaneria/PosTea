import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:postea_frontend/customWidgets/topic_pill.dart';

class DiscoverTopics extends StatefulWidget {
  final profileID;
  DiscoverTopics({this.profileID});

  @override
  _DiscoverTopicsState createState() => _DiscoverTopicsState();
}

class _DiscoverTopicsState extends State<DiscoverTopics> {
  var _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Discover...",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                // color: Colors.greenAccent,
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 4,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            NetworkImage("https://picsum.photos/250?image=180"),
                        fit: BoxFit.cover)),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Container(
                        //   alignment: Alignment.center,
                        //   color: Colors.grey.withOpacity(0.1),
                        //   child: Text(
                        //     "Discover...",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 30,
                        //         color: Colors.white),
                        //   ),
                        // ),
                        Container(
                          color: Colors.grey.withOpacity(0.1),
                          height: screenHeight / 14,
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth / 15, vertical: 10),
                          child: ButtonTheme(
                            buttonColor: Colors.red[50],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            minWidth: screenWidth / 5,
                            child: RaisedButton(
                              elevation: 2,
                              clipBehavior: Clip.antiAlias,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.search),
                                  Text("Search Topics")
                                ],
                              ),
                              onPressed: () {},
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                height: 50,
                width: screenWidth,
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  children: [
                    TopicPill(
                      topicId: 2,
                      col1: Colors.purple[900],
                      col2: Colors.purple[400],
                      height: screenHeight / 10,
                      width: screenWidth / 4,
                      profileId: widget.profileID,
                      isOwner: true,
                    ),
                    TopicPill(
                      topicId: 26894,
                      col1: Colors.green[700],
                      col2: Colors.lightGreen[400],
                      height: screenHeight / 10,
                      width: screenWidth / 4,
                      profileId: widget.profileID,
                      isOwner: true,
                    ),
                    TopicPill(
                      topicId: 51561,
                      col1: Colors.blue[700],
                      col2: Colors.lightBlueAccent[200],
                      height: screenHeight / 10,
                      width: screenWidth / 4,
                      profileId: widget.profileID,
                      isOwner: true,
                    ),
                    TopicPill(
                      topicId: 99841,
                      col1: Colors.red[700],
                      col2: Colors.pink[400],
                      height: screenHeight / 10,
                      width: screenWidth / 4,
                      profileId: widget.profileID,
                      isOwner: true,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
