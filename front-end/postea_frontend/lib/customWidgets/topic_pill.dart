import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postea_frontend/colors.dart';
import '../pages/topic.dart';

class TopicPill extends StatefulWidget {
  var profileId;
  bool isOwner;
  var topicId;
  Color col1;
  Color col2;
  var height;
  var width;

  TopicPill(
      {@required this.topicId,
      this.col1,
      this.col2,
      this.height,
      this.width,
      this.profileId,
      this.isOwner});
  @override
  _TopicPillState createState() => _TopicPillState();
}

// final ValueNotifier<String> topicNameNotifier = new ValueNotifier<String>("");

class _TopicPillState extends State<TopicPill> {
  @override
  void initState() {
    // TODO: implement initState
    getTopicName();
    super.initState();
  }

  var name = "";
  ValueNotifier<String> pillText = ValueNotifier<String>("");
  getTopicName() async {
    http
        .get("http://postea-server.herokuapp.com/topic?topic_id=" +
            widget.topicId.toString())
        .then((value) {
      var valueString = jsonDecode(value.body);
      pillText.value = valueString[0]['topic_name'];
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Topic(
                        profileId: widget.profileId,
                        isOwner: widget.isOwner,
                        topicId: widget.topicId,
                      )));
        },
          child: Container(
        margin: EdgeInsets.only(top: 5, left: 5, right: 5),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          // border: Border.all(color: bgColor),
            gradient: LinearGradient(colors: [widget.col1, widget.col2]),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Center(
            child: ValueListenableBuilder(
              valueListenable: pillText,
              builder: (_, value, __) =>
              AutoSizeText(
          value,
          style: TextStyle(fontSize: 13, color: Colors.white),
        ),
            )),
      ),
    );
  }
}
