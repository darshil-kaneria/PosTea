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

  Future<http.Response> getFollowingList() async {
    followingList = [];
    print("hello before taking topic list");
    http.Response resp = await http.get(
        "http://postea-server.herokuapp.com/getFollowingTopics?profile_id=" +
            widget.profileId.toString());
    print("topic following list is " + json.decode(resp.body).toString());
    return resp;
  }

  initializeSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    var followingString = widget.name.toString() + " is following";
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight / 1.2,
      margin: EdgeInsets.all(14),
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
              itemCount: followingList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    initializeSharedPref();
                    var topicIDList = prefs.getStringList('topicIDList');
                    if (topicIDList.contains(topicIDs[index])) {
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
