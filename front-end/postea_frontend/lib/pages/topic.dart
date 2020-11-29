import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postea_frontend/customWidgets/postTile.dart';
import 'package:postea_frontend/main.dart';
import 'package:postea_frontend/data_models/process_topic.dart';
import 'package:http/http.dart' as http;
import 'package:postea_frontend/pages/homepage.dart';

import '../colors.dart';

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
  var checkPosScrollController = new ScrollController();
  ValueNotifier<String> topicFollowingText = ValueNotifier<String>("Follow");
  ValueNotifier<bool> isFollow = ValueNotifier<bool>(false);

  ValueNotifier<String> topicNameNotifier = ValueNotifier("");
  ValueNotifier<String> topicDescNotifier = ValueNotifier("");

  TextEditingController topicNameController = new TextEditingController();
  TextEditingController topicDescController = new TextEditingController();

  File topicPic;
  // var isOwner;

  // _TopicState({this.isOwner});

  _scrollListener() {
    if (checkPosScrollController.offset <=
            checkPosScrollController.position.minScrollExtent &&
        !checkPosScrollController.position.outOfRange) {
      setState(() {
        offset = 0;
        print("Timeline refreshed");
        topic.clearTimeline();
      });
    }

    if (checkPosScrollController.offset >=
            checkPosScrollController.position.maxScrollExtent &&
        !checkPosScrollController.position.outOfRange) {
      print("ISPOST" + topic.postRetrieved.toString());
      if (!topic.isEnd && topic.postRetrieved)
        setState(() {
          print("SETSTATE CALLED");
          offset = offset + 10;
          // updatePost();
        });
    }
  }

  ProcessTopic topic;
  Map<String, dynamic> topicInfo;

  getTopicInfo() async {
    topic.getTopicInfo().then((value) {
      topicInfo = value;
      topicNameNotifier.value = topicInfo['name'];
      topicDescNotifier.value = topicInfo['desc'];
      topicDescController.text = topicInfo['desc'];
      print(topicInfo);
    });
  }

  deleteTopic() async {
    final request = http.Request(
      "DELETE",
      Uri.parse("http://postea-server.herokuapp.com/topic"),
    );
    request.headers.addAll({'Content-Type': 'application/json'});
    request.body =
        jsonEncode({"topic_id": widget.topicId, "user_id": widget.profileId});
    await request.send();
  }

  updateTopicDesc(String newTopicDesc) async {
    var topicData = {
      "originalTopicID": widget.topicId,
      "creator_id": widget.profileId,
      "user_id": widget.profileId,
      "update_topic_desc": newTopicDesc
    };
    var topicDataJson = JsonEncoder().convert(topicData);
    await http.post("http://postea-server.herokuapp.com/updateTopicDesc",
        headers: {'Content-Type': 'application/json'}, body: topicDataJson);
  }

  Future<http.Response> createNewTopic() async {
    Random random = new Random();
    widget.topicId = (random.nextInt(10000000));

    print("topic id is " + widget.topicId.toString());
    var topic_info = {
      "topicText": topicNameController.text,
      "topicCreatorID": widget.profileId,
      "topicDescription": topicDescController.text,
      "topicID": widget.topicId
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

  Future<Response> getTopicContent() async {
    await topic.setOffset(offset);
    return await topic.getPosts();
  }

  getTopicFollowing() async {
    var url = "http://postea-server.herokuapp.com/userfollowedtopics?user_id=" +
        widget.profileId.toString() +
        "&flag=topic_list";

    http.get(url).then((value) {
      var topicList = jsonDecode(value.body);
      print(value.body);

      for (var i = 0; i < topicList.length; i++) {
        if (topicList[i]['topic_id'].toString() == widget.topicId) {
          topicFollowingText.value = "Following";
          isFollow.value = true;
          buttonColor.value = Colors.redAccent[100];
        }
      }
      // setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    topic = new ProcessTopic(
        profile_id: widget.profileId,
        topic_id: int.parse(widget.topicId.toString()));
    topicInfo = {"name": "", "desc": ""};
    getTopicInfo();
    getTopicFollowing();
    setState(() {});
    // getTopicContent();
    checkPosScrollController.addListener(_scrollListener);
    super.initState();
  }

  ValueNotifier<Color> buttonColor = ValueNotifier<Color>(Colors.red[50]);
  PageController topicPageController = new PageController();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    print("TOPIC ID is " + widget.topicId.toString());
    return PageView(
      controller: topicPageController,
      children: [
        SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              actions: [
                widget.isOwner
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          topicPageController.jumpToPage(1);
                        },
                      )
                    : Container()
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Container(
              height: screenHeight,
              width: screenWidth,
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
                              image: NetworkImage(
                                  "https://picsum.photos/250?image=180"),
                              fit: BoxFit.cover)),
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                color: Colors.grey.withOpacity(0.1),
                                child: ValueListenableBuilder(
                                    valueListenable: topicNameNotifier,
                                    builder: (_, value, __) {
                                      return Text(
                                        // "Chess",
                                        value,
                                        style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      );
                                    }),
                              ),
                              widget.isOwner == false
                                  ? Container(
                                      height: screenHeight / 14,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth / 15,
                                          vertical: 10),
                                      child: ValueListenableBuilder(
                                        valueListenable: isFollow,
                                        builder: (_, isFollowValue, __) =>
                                            ButtonTheme(
                                                buttonColor: buttonColor.value,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                minWidth: screenWidth / 5,
                                                child: RaisedButton(
                                                    elevation: 2,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: Text(
                                                        topicFollowingText
                                                            .value),
                                                    onPressed: () async {
                                                      print(
                                                          "IS FOLLOW VALUE: " +
                                                              isFollowValue
                                                                  .toString());

                                                      if (isFollowValue) {
                                                        buttonColor.value =
                                                            Colors.red[50];
                                                        isFollow.value = false;
                                                        topicFollowingText
                                                            .value = "Follow";
                                                        final request =
                                                            http.Request(
                                                                "DELETE",
                                                                Uri.parse(
                                                                    "http://postea-server.herokuapp.com/topicfollowdata"));
                                                        request.headers.addAll({
                                                          'Content-Type':
                                                              'application/json'
                                                        });
                                                        request.body =
                                                            jsonEncode({
                                                          "topic_id":
                                                              widget.topicId,
                                                          "follower_id":
                                                              widget.profileId
                                                        });
                                                        request.send();
                                                      } else {
                                                        buttonColor.value =
                                                            Colors
                                                                .redAccent[100];
                                                        isFollow.value = true;
                                                        topicFollowingText
                                                                .value =
                                                            "Following";
                                                        var addfollowing = {
                                                          "topic_id":
                                                              widget.topicId,
                                                          "follower_id":
                                                              widget.profileId
                                                        };
                                                        var addfollowingJson =
                                                            JsonEncoder().convert(
                                                                addfollowing);
                                                        http.post(
                                                            "http://postea-server.herokuapp.com/topicfollowdata",
                                                            headers: {
                                                              'Content-Type':
                                                                  'application/json'
                                                            },
                                                            body:
                                                                addfollowingJson);
                                                      }

                                                      // setState(() {});
                                                    })),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   flex: 1,
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     child: ValueListenableBuilder(
                  //         valueListenable: topicNameNotifier,
                  //         builder: (_, value, __) {
                  //           return Text(
                  //             // "Chess",
                  //             value,
                  //             style: TextStyle(fontSize: 20),
                  //           );
                  //         }),
                  //   ),
                  // ),
                  // Expanded(
                  //     flex: 1,
                  //     child: widget.isOwner == false
                  //         ? Container(
                  //             height: screenHeight / 14,
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: screenWidth / 15, vertical: 10),
                  //             child: ButtonTheme(
                  //                 buttonColor: buttonColor,
                  //                 shape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(30)),
                  //                 minWidth: screenWidth / 5,
                  //                 child: RaisedButton(
                  //                     elevation: 2,
                  //                     clipBehavior: Clip.antiAlias,
                  //                     child: Text(topicFollowingText),
                  //                     onPressed: () async {
                  //                       print(isFollow);

                  //                       if (isFollow) {
                  //                         buttonColor = Colors.red[50];
                  //                         isFollow = false;
                  //                         topicFollowingText = "Follow";
                  //                         final request = http.Request(
                  //                             "DELETE",
                  //                             Uri.parse(
                  //                                 "http://postea-server.herokuapp.com/topicfollowdata"));
                  //                         request.headers.addAll(
                  //                             {'Content-Type': 'application/json'});
                  //                         request.body = jsonEncode({
                  //                           "topic_id": widget.topicId,
                  //                           "follower_id": widget.profileId
                  //                         });
                  //                         request.send();
                  //                       } else {
                  //                         buttonColor = Colors.redAccent[100];
                  //                         isFollow = true;
                  //                         topicFollowingText = "Following";
                  //                         var addfollowing = {
                  //                           "topic_id": widget.topicId,
                  //                           "follower_id": widget.profileId
                  //                         };
                  //                         var addfollowingJson =
                  //                             JsonEncoder().convert(addfollowing);
                  //                         http.post(
                  //                             "http://postea-server.herokuapp.com/topicfollowdata",
                  //                             headers: {
                  //                               'Content-Type': 'application/json'
                  //                             },
                  //                             body: addfollowingJson);
                  //                       }

                  //                       setState(() {});
                  //                     })),
                  //           )
                  //         : Container()),
                  Expanded(
                    flex: 1,
                    child: Card(
                      // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      clipBehavior: Clip.hardEdge,
                      elevation: 0,
                      child: Container(
                        color: bgGradStart,
                        width: screenWidth,
                        child: SingleChildScrollView(
                            child: ValueListenableBuilder(
                                valueListenable: topicDescNotifier,
                                builder: (_, value, __) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                })),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    // child: Container(
                    //   // color: Colors.limeAccent,
                    //   child: ListView(
                    //     addRepaintBoundaries: false,
                    //     shrinkWrap: true,
                    //     padding: EdgeInsets.all(0),
                    //     children: [
                    //       Container(height: screenHeight/3, width: screenWidth, color: Colors.grey,),
                    //       Container(height: screenHeight/3, width: screenWidth, color: Colors.pinkAccent,),
                    //       Container(height: screenHeight/3, width: screenWidth, color: Colors.orangeAccent,),
                    //       Container(height: screenHeight/3, width: screenWidth, color: Colors.yellowAccent,),
                    //       Container(height: screenHeight/3, width: screenWidth, color: Colors.blueAccent,)
                    //     ],
                    //   ),
                    // )
                    child: FutureBuilder(
                      future: getTopicContent(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData)
                          return ListView.builder(
                            padding: EdgeInsets.all(0),
                            physics: BouncingScrollPhysics(),
                            controller: checkPosScrollController,
                            itemCount: topic.postList.length,
                            itemBuilder: (context, index) {
                              return PostTile(
                                  topic.postList.elementAt(index).post_id,
                                  topic.postList.elementAt(index).profile_id,
                                  topic.postList
                                      .elementAt(index)
                                      .post_description,
                                  topic.postList.elementAt(index).topic_id,
                                  topic.postList.elementAt(index).post_img,
                                  topic.postList.elementAt(index).creation_date,
                                  topic.postList.elementAt(index).post_likes,
                                  topic.postList.elementAt(index).post_dislikes,
                                  topic.postList.elementAt(index).post_comments,
                                  topic.postList.elementAt(index).post_title,
                                  topic.postList.elementAt(index).post_name,
                                  widget.profileId.toString(),
                                  0);
                            },
                          );
                        else
                          return Center(
                              child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(bgGradEnd),
                          ));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Container(
            color: Theme.of(context).canvasColor,
            width: screenWidth,
            height: screenHeight,
            child: Material(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          topicPageController.jumpToPage(0);
                        },
                      ),
                      Text(
                        "Edit Topic Page",
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await deleteTopic();
                          print("TOPIC DELETED SUCCESSFULLY");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(profileID: widget.profileId)));
                        },
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height / 7,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: FutureBuilder(
                            future: FirebaseStorageService.getImage(
                                context, widget.topicId.toString()),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data),
                                  maxRadius: screenWidth / 5,
                                );
                              } else {
                                return CircleAvatar(
                                  maxRadius: screenWidth / 5,
                                  backgroundImage: NetworkImage(
                                      "https://picsum.photos/250?image=18"),
                                );
                              }
                            },
                          ),
                          onTap: () async {
                            await chooseTopicPic();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Click to edit image",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ValueListenableBuilder(
                        valueListenable: topicNameNotifier,
                        builder: (_, value, __) {
                          return Text(
                            // "Chess",
                            value,
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          );
                        }),
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
                        child: Column(
                          children: [
                            Text(
                              "Enter New Topic Description:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10),
                              child: TextField(
                                maxLines: 4,
                                textAlign: TextAlign.left,
                                controller: topicDescController,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter Description",
                                    hintStyle:
                                        Theme.of(context).textTheme.headline3),
                              ),
                            ),
                          ],
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
                              "Edit Topic",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () async {
                              await updateTopicDesc(topicDescController.text);
                              await uploadTopicPic(
                                  topicPic, widget.topicId.toString());
                              topicDescNotifier.value =
                                  topicDescController.text;
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();
  static Future<dynamic> getImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance
        .ref()
        .child("topic")
        .child(image)
        .getDownloadURL();
  }
}
