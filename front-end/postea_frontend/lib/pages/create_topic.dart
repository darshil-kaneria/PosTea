import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:math';

class CreateTopic extends StatefulWidget {
  var profile_id;

  CreateTopic({this.profile_id});

  @override
  _CreateTopicState createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  var topicNameController = new TextEditingController();
  var topidDescController = new TextEditingController();
  var topicID;

  File topicPic;

  _CreateTopicState();

  Future<http.Response> createNewTopic() async {
    Random random = new Random();
    topicID = (random.nextInt(10000000));

    print("topic id is " + topicID.toString());
    var topic_info = {
      "topicText": topicNameController.text,
      "topicCreatorID": widget.profile_id,
      "topicDescription": topidDescController.text,
      "topicID": topicID
    };
    var topic_info_json = jsonEncode(topic_info);

    var url = "http://postea-server.herokuapp.com/topic";

    print("sending " + topic_info_json.toString());
    http.Response response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: topic_info_json);

    print(response.body);

    return response;
  }

  chooseTopicPic() async {
    // PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery);
    print("about to choose image");
    ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      print("In dot then");
      print(value);
      topicPic = value;
    });
    print("chosen image is " + topicPic.toString());
    print(topicPic);
  }

  Future uploadTopicPic(File file, String topicID) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("topic").child(topicID);
    print("before query");
    await storageReference.putFile(file).onComplete;
    print("after query");
    print("Uploaded image to Firebase from edit profile");
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      appBar: new AppBar(
        title: Text(
          "Create a New Topic",
          style: Theme.of(context).textTheme.headline4,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).buttonColor),
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
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
                  GestureDetector(
                    child: CircleAvatar(
                      maxRadius: screenWidth / 5,
                      backgroundImage:
                          NetworkImage("https://picsum.photos/250?image=18"),
                    ),
                    onTap: () async {
                      await chooseTopicPic();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Click to choose image",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
                controller: topicNameController,
                decoration: InputDecoration(
                    labelText: "What topic would you like to create?",
                    labelStyle: Theme.of(context).textTheme.headline1),
              ),
            ),
            Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 20, left: 15, right: 15),
              width: screenWidth,
              height: screenHeight / 4,
              child: Card(
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    maxLines: 4,
                    textAlign: TextAlign.left,
                    controller: topidDescController,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter Description",
                        hintStyle: Theme.of(context).textTheme.headline3),
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
                      color: Theme.of(context).bottomAppBarColor,
                      child: Text(
                        "Create Topic",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () async {
                        await createNewTopic();
                        await uploadTopicPic(topicPic, topicID.toString());
                        Navigator.pop(context);
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
