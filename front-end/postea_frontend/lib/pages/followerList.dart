import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../colors.dart';

class FollowerList extends StatefulWidget {
  var profileId;
  var name;

  FollowerList({this.profileId, this.name});
  @override
  _FollowerListState createState() => _FollowerListState();
}

class _FollowerListState extends State<FollowerList> {
  List<String> followingList = [];
  List<String> profileIDs = [];
  Future<http.Response> getFollowingList() async {
    followingList = [];
    print("hello before taking follow data");
    http.Response resp = await http.get(
      "http://postea-server.herokuapp.com/followdata?profile_id=" +
          widget.profileId.toString() +
          "&flag=follower_list",
    );

    print("follower data is " + json.decode(resp.body).toString());
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    var followerString = "Followers of " + widget.name.toString();
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          followerString,
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(14),
        child: FutureBuilder(
          future: getFollowingList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print("HERE");
              var temp = jsonDecode(snapshot.data.body);
              for (var i = 0; i < temp.length; i++) {
                followingList.add(temp[i]['name'].toString());
                profileIDs.add(temp[i]['profile_id'].toString());
              }
              return ListView.builder(
                itemCount: followingList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: FutureBuilder(
                      future: FirebaseStorageService.getImage(
                          context, profileIDs[index].toString()),
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
                      valueColor: AlwaysStoppedAnimation(bgGradEnd)));
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
