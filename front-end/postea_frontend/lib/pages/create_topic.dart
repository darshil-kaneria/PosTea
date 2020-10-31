import 'dart:convert';

import 'package:flutter/material.dart';
import '../colors.dart';
import 'package:http/http.dart' as http;

class CreateTopic extends StatefulWidget {
  var profile_id;

  CreateTopic({this.profile_id});

  @override
  _CreateTopicState createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  var topicNameController = new TextEditingController();
  var topidDescController = new TextEditingController();
  var profile_id;

  _CreateTopicState({this.profile_id});

  Future<http.Response> createNewTopic() async {
    var topic_info = {
      "topicText": topicNameController.text,
      "topicID": 20,
      "topicCreatorID": this.profile_id,
      "topicDescription": topidDescController.text
    };
    var topic_info_json = jsonEncode(topic_info);

    var url = "http://postea-server.herokuapp.com/topic";

    print("sending " + topic_info_json.toString());
    http.Response response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: topic_info_json);

    print(response.body);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: new AppBar(
        title: Text("Create a New Topic"),
      ),
      body: Container(
        color: bgColor,
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height / 7,
              child: Column(
                children: [
                  CircleAvatar(
                    maxRadius: screenWidth / 5,
                    backgroundImage:
                        NetworkImage("https://picsum.photos/250?image=18"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Click to choose image",
                      style: TextStyle(
                          fontSize: 15, decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: TextStyle(fontSize: 22.7, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                controller: topicNameController,
                decoration: InputDecoration(
                    labelText: "What topic would you like to create?"),
              ),
            ),
            Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 20, left: 15, right: 15),
              width: screenWidth,
              height: screenHeight / 4,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    maxLines: 4,
                    textAlign: TextAlign.left,
                    controller: topidDescController,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter Description"),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: screenHeight / 12,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonTheme(
                  child: RaisedButton(
                      color: bottomGrad,
                      child: Text(
                        "Create Topic",
                        style: TextStyle(fontSize: 20),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () async {
                        await createNewTopic();
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
