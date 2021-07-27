import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../pages/topic.dart';

class TopicCard extends StatefulWidget {
  var profileId;
  bool isOwner;
  var topicId;
  Color col1;
  Color col2;
  var height;
  var width;
  bool gradient;

  TopicCard(
      {@required this.topicId,
      this.col1,
      this.col2,
      this.height,
      this.width,
      this.profileId,
      this.isOwner,
      this.gradient});
  
  @override
  _TopicCardState createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  @override
  void initState() {
    // TODO: implement initState
    getTopicName();
    super.initState();
  }

  var name = "";
  ValueNotifier<String> cardText = ValueNotifier<String>("");
  getTopicName() async {
    http.get(
      "http://postea-server.herokuapp.com/topic?topic_id=" +
          widget.topicId.toString(),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer posteaadmin",
      },
    ).then((value) {
      var valueString = jsonDecode(value.body);
      cardText.value = valueString[0]['topic_name'];
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var col = Colors.black;
    if (widget.gradient == null) {
      widget.gradient = true;
    } 
    // else if (widget.gradient == false) {
    //   while (col.computeLuminance() <= 0.5) {
    //     col = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    //   }
    // }

    // var color1 = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    // var color2 = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    // var textColor = Theme.of(context).textTheme.bodyText1.color;
    // while ((color1.computeLuminance() <= 0.5 && color2.computeLuminance() <= 0.5) || (color1.computeLuminance() > 0.5 && color2.computeLuminance() > 0.5)) {
    //   if ((color1.computeLuminance() <= 0.5 && color2.computeLuminance() > 0.5) || color1.computeLuminance() > 0.5 && color2.computeLuminance() <= 0.5) {
    //     color1 = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    //     color2 = Colors.primaries[Random().nextInt(Colors.primaries.length)];      
    //   }
    // }

    // if (color1.computeLuminance() <= 0.5) {
    //   textColor = Colors.white;
    // }

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
        // decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.primaries[Random().nextInt(Colors.primaries.length)], Colors.primaries[Random().nextInt(Colors.primaries.length)]])),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: widget.gradient ? 1.5 : 2.5,
          shape: widget.gradient ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) : RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Container(
            // color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            decoration: widget.gradient ? BoxDecoration(gradient: LinearGradient(colors: [Colors.primaries[Random().nextInt(Colors.primaries.length)], Colors.primaries[Random().nextInt(Colors.primaries.length)]])) : BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: ShapeDecoration(
                          shape: CircleBorder(
                            side: BorderSide(
                            width: 2,
                            color: Colors.blue[300]))),
                          child: Container(
                          height: widget.height / 7,
                          width: widget.width / 3.5,
                          decoration: ShapeDecoration(
                            shape: CircleBorder(
                              side: BorderSide(
                                width: 3,
                                color: Colors.orange[50]))),
                          child: FutureBuilder(
                            future: FirebaseStorageService.getImage(context, widget.profileId.toString()),
                            builder: (context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data),
                                  maxRadius: screenWidth / 15,
                                  );
                              } else {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage('https://picsum.photos/250?image=18'),
                                  maxRadius: screenWidth / 15,
                                );
                                // return CircularProgressIndicator(
                                //   strokeWidth: 2,
                                //   backgroundColor:
                                //       bgColor,
                                //   valueColor:
                                //       AlwaysStoppedAnimation(
                                //           loginButtonEnd),
                                // );
                              }
                            }),
                        ),
                      ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ValueListenableBuilder(
                            valueListenable: cardText,
                            builder: (_, value, __) => AutoSizeText(
                              value,
                              style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyText1.color),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: AutoSizeText("1M posts", style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodyText1.color),)
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: AutoSizeText("10M followers", style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodyText1.color),)
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}