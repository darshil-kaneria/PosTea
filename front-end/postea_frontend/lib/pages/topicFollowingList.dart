import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postea_frontend/pages/profile.dart';
import 'package:postea_frontend/pages/topic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../colors.dart';

class TopicFollowingList extends StatefulWidget {
  var profileId;
  var name;

  TopicFollowingList({this.profileId, this.name});
  @override
  _TopicFollowingListState createState() => _TopicFollowingListState();
}

class _TopicFollowingListState extends State<TopicFollowingList> {
  List<String> followingList = [];
  List<String> topicIDs = [];
  SharedPreferences prefs;
  ValueNotifier<String> topicFollowingText = ValueNotifier<String>("Follow");
  ValueNotifier<bool> isFollow = ValueNotifier<bool>(false);

  ValueNotifier<String> topicNameNotifier = ValueNotifier("");
  ValueNotifier<String> topicDescNotifier = ValueNotifier("");
  ValueNotifier<Color> buttonColor = ValueNotifier<Color>(Colors.red[50]);

  Future<http.Response> getFollowingList() async {
    followingList = [];
    print("hello before taking topic list");
    http.Response resp = await http.get(
      "http://postea-server.herokuapp.com/getFollowingTopics?profile_id=" +
          widget.profileId.toString(),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer posteaadmin",
      },
    );
    print("topic following list is " + json.decode(resp.body).toString());
    return resp;
  }

  initializeSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var followingString = widget.name.toString() + " is following";
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight / 3.5,
      margin: EdgeInsets.only(left: 12, right: 12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(25),),
        elevation: 1.5,
        child: FutureBuilder(
          future: getFollowingList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print("HERE");
              var temp = jsonDecode(snapshot.data.body);
              print("temp is " + temp.toString());
              for (var i = 0; i < temp.length; i++) {
                followingList.add(temp[i]['topic_name'].toString());
                topicIDs.add(temp[i]['topic_id'].toString());
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: followingList.length,
                itemBuilder: (context, index) {
                  return Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: screenWidth / 2,
                        child: ListTile(
                          onTap: () async {
                            var topicIDList = prefs.getStringList('topicIDList');
                            if (topicIDList.contains(topicIDs[index])) {
                              topicFollowingText.value = "Following";
                              isFollow.value = true;
                              buttonColor.value = Colors.redAccent[100];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Topic(
                                    profileId: int.parse(widget.profileId),
                                    topicId: topicIDs[index],
                                    isOwner: true,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Topic(
                                    profileId: int.parse(widget.profileId),
                                    topicId: topicIDs[index],
                                    isOwner: false,
                                  ),
                                ),
                              );
                            }
                          },
                          leading: FutureBuilder(
                            future: FirebaseStorageService.getImage(
                                context, topicIDs[index].toString()),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data),
                                  maxRadius: screenWidth / 20,
                                );
                              } else {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://picsum.photos/250?image=18"),
                                  maxRadius: screenWidth / 20,
                                );
                              }
                            },
                          ),
                          title: Text(followingList[index].toString()),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          child: ValueListenableBuilder(
                            valueListenable: isFollow,
                            builder: (_, isFollowValue, __) => Container(
                              height: screenHeight / 25,
                              child: ButtonTheme(
                                buttonColor: buttonColor.value,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                minWidth: screenWidth / 6.5,
                                child: RaisedButton(
                                  elevation: 2,
                                  clipBehavior: Clip.antiAlias,
                                  child: Text(topicFollowingText.value),
                                  onPressed: () async {
                                    print("IS FOLLOW VALUE: " +
                                        isFollowValue.toString());

                                    if (isFollowValue) {
                                      buttonColor.value = Colors.red[50];
                                      isFollow.value = false;
                                      topicFollowingText.value = "Follow";
                                      final request = http.Request(
                                          "DELETE",
                                          Uri.parse(
                                              "http://postea-server.herokuapp.com/topicfollowdata"));
                                      request.headers.addAll(
                                        {
                                          'Content-Type': 'application/json',
                                          HttpHeaders.authorizationHeader:
                                              "Bearer posteaadmin",
                                        },
                                      );
                                      request.body = jsonEncode(
                                        {
                                          "topic_id": topicIDs[index],
                                          "follower_id": widget.profileId
                                        },
                                      );
                                      request.send();
                                    } else {
                                      buttonColor.value = Colors.redAccent[100];
                                      isFollow.value = true;
                                      topicFollowingText.value = "Following";
                                      var addfollowing = {
                                        "topic_id": topicIDs[index],
                                        "follower_id": widget.profileId
                                      };
                                      var addfollowingJson =
                                          JsonEncoder().convert(addfollowing);
                                      http.post(
                                          "http://postea-server.herokuapp.com/topicfollowdata",
                                          headers: {
                                            'Content-Type': 'application/json',
                                            HttpHeaders.authorizationHeader:
                                                "Bearer posteaadmin",
                                          },
                                          body: addfollowingJson);
                                    }

                                    // setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(bgGradEnd),
              ));
          },
        ),
      ),
    );
  }
}

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();
  static Future<dynamic> getImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(image)
        .getDownloadURL();
  }
}
