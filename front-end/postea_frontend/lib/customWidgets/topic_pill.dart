import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TopicPill extends StatefulWidget {

  var topicId;
  Color col1;
  Color col2;
  var height;
  var width;

  TopicPill({@required this.topicId, this.col1, this.col2, this.height, this.width});
  @override
  _TopicPillState createState() => _TopicPillState();
}

class _TopicPillState extends State<TopicPill> {
  @override
  void initState() {
    // TODO: implement initState
    getTopicName();
    super.initState();
  }

  Future<http.Response> getTopicName() async {

      http.Response resp = await http.get("http://postea-server.herokuapp.com/topic?topic_id="+widget.topicId.toString());
      return resp;
    }
  @override
  Widget build(BuildContext context) {

      

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(

      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          widget.col1,
          widget.col2
        ]),
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      child: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            if(snapshot.hasData){
              print(snapshot.data);
              return AutoSizeText(
            "HELLO",
            style: TextStyle(fontSize: 20, color: Colors.white),
          );
            }
            else{
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      
    );
  }
  }


