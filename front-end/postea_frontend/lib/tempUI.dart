import 'dart:io';

import 'package:flutter/material.dart';
import 'data_models/process_topic.dart';

class TempUI extends StatefulWidget {
  @override
  _TempUIState createState() => _TempUIState();
}

class _TempUIState extends State<TempUI> {
  ProcessTopic processTopic = new ProcessTopic(topic_id: 2);
  ProcessTopic processTopic2 = new ProcessTopic(
      topic_name: "Postea",
      topic_creator_id: 79341,
      topic_description: "Postea is a very nice app!");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      body: Container(
        child: Column(
          children: [
            RaisedButton(
              onPressed: () async {
                var resp = await processTopic.getTopicInfo();
                print("resp.name is " + resp["name"]);
                print("resp.desc is " + resp["desc"]);
              },
              child: Text("Get Topic Information"),
            ),
            RaisedButton(
              onPressed: () async {
                var resp = await processTopic.makeTopic();
                print("resp.body is " + resp.body.toString());
              },
              child: Text("Make Topic"),
            )
          ],
        ),
      ),
    );
  }
}
