import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postea_frontend/pages/profile.dart';
import 'dart:convert';

import '../colors.dart';

class FollowingList extends StatefulWidget {
  var profileId;
  var name;

  FollowingList({this.profileId, this.name});
  @override
  _FollowingListState createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  List<String> followingList = [];
  List<String> profileIDs = [];
  Future<http.Response> getFollowingList() async {
    followingList = [];
    print("hello before taking following data list");
    http.Response resp = await http.get(
      "http://postea-server.herokuapp.com/followdata?profile_id=" +
          widget.profileId.toString() +
          "&flag=following_list",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer posteaadmin",
      },
    );
    print("following list is " + json.decode(resp.body).toString());
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    var followingString = widget.name.toString() + " is following";
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        title: Text(
          followingString,
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
            IconThemeData(color: Theme.of(context).accentIconTheme.color),
      ),
      body: Container(
        margin: EdgeInsets.all(14),
        child: FutureBuilder(
          future: getFollowingList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print("HERE");
              var temp = jsonDecode(snapshot.data.body);
              print("temp is " + temp.toString());
              for (var i = 0; i < temp.length; i++) {
                followingList.add(temp[i]['name'].toString());
                profileIDs.add(temp[i]['profile_id'].toString());
              }
              return ListView.builder(
                itemCount: followingList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(
                            profileId: int.parse(profileIDs[index]),
                            isOwner: false,
                          ),
                        ),
                      );
                    },
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
