import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postea_frontend/data_models/post.dart';
import 'dart:convert';
import 'package:postea_frontend/data_models/process_timeline.dart';
import 'dart:core';

class DevPage extends StatefulWidget {
  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {


  ProcessTimeline timeLine = new ProcessTimeline(1);

  var textFieldProfile = TextEditingController();
  var textFieldOffset = TextEditingController();
  var offset = 0;

  Future<http.Response> updatePost() async{
    await timeLine.setOffset(offset);
    return await timeLine.getPosts();
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            TextField(
              controller: textFieldProfile,
              decoration: InputDecoration(
                hintText: "profile"
              ),
              
          ),
          TextField(
              controller: textFieldOffset,
              decoration: InputDecoration(
                hintText: "offset"
              ),
              
            ),
          FlatButton(onPressed: () async {
            // refresh
            setState(() {
              offset = offset+2;
              updatePost();
            });
            

          }, child: Text("refresh")),
          Container(
            height: MediaQuery.of(context).size.height/1.5,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: timeLine.postList.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  child: Column(
                    children: [
                      Text(timeLine.postList.elementAt(index).profile_id),
                      Text(timeLine.postList.elementAt(index).post_title),
                      Text(timeLine.postList.elementAt(index).post_description),
                      Text(timeLine.postList.elementAt(index).post_likes),
                    ],
                  ),

                );
              }
              ),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){

            var profile_id = textFieldProfile.text;
            var offset = textFieldOffset.text;

            print(profile_id + " : " + offset);

            setState(() {
              this.offset = int.parse(offset);
            });

        }),
    );
  }
}



