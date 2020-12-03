import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postea_frontend/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../colors.dart';

class FollowerList extends StatefulWidget {
  var profileId;
  var myPID;
  var name;

  FollowerList({this.profileId, this.name});
  @override
  _FollowerListState createState() => _FollowerListState();
}

class _FollowerListState extends State<FollowerList> {
  List<String> followingList = [];
  List<String> profileIDs = [];
  SharedPreferences prefs;
  List<dynamic> listFollowing;
  var isFollow = false;
  var buttonColor = Colors.red[50];
  var followButtonText = "Follow";

  Future<http.Response> getFollowingList() async {
    followingList = [];
    print("hello before taking follow data");
    http.Response resp = await http.get(
      "http://postea-server.herokuapp.com/followdata?profile_id=" +
          widget.profileId.toString() +
          "&flag=follower_list",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer posteaadmin",
      },
    );

    print("follower data is " + json.decode(resp.body).toString());
    return resp;
  }

  getFollowing() async {
    prefs = await SharedPreferences.getInstance();
    widget.myPID = prefs.getInt('profileID') ?? 0;
    print("MY ID" + widget.profileId.toString());
    http.get(
      "http://postea-server.herokuapp.com/followdata?profile_id=" +
          widget.profileId.toString() +
          "&flag=following_list",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer posteaadmin",
      },
    ).then((resp) {
      listFollowing = jsonDecode(resp.body);
      print("LIST FOLLOWING" + listFollowing.toString());
      for (int i = 0; i < listFollowing.length; i++) {
        // print()
        if (listFollowing[i]['follower_id'] == widget.profileId) {
          isFollow = true;
          buttonColor = Colors.redAccent[100];
          isFollow = true;
          followButtonText = "Following";
          setState(() {});
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollowing();
  }

  @override
  Widget build(BuildContext context) {
    var followerString = "Followers of " + widget.name.toString();
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

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
                  return Row(
                    children: [
                      Container(
                        width: screenWidth / 2,
                        child: ListTile(
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
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: screenHeight / 25,
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: screenWidth / 15, vertical: 10),
                        child: ButtonTheme(
                            buttonColor: buttonColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            minWidth: screenWidth / 15,
                            child: RaisedButton(
                                elevation: 2,
                                clipBehavior: Clip.antiAlias,
                                child: Text(followButtonText),
                                onPressed: () async {
                                  print(isFollow);

                                  if (isFollow) {
                                    buttonColor = Colors.red[50];
                                    isFollow = false;
                                    followButtonText = "Follow";
                                    final request = http.Request(
                                        "DELETE",
                                        Uri.parse(
                                            "http://postea-server.herokuapp.com/followdata"));
                                    request.headers.addAll(
                                      {
                                        'Content-Type': 'application/json',
                                        HttpHeaders.authorizationHeader:
                                            "Bearer posteaadmin",
                                      },
                                    );
                                    request.body = jsonEncode(
                                      {
                                        "profile_id": widget.profileId,
                                        "follower_id": profileIDs[index],
                                      },
                                    );
                                    request.send();
                                  } else {
                                    buttonColor = Colors.redAccent[100];
                                    isFollow = true;
                                    followButtonText = "Following";
                                    var addfollowing = {
                                      "profile_id": widget.profileId,
                                      "follower_id": profileIDs[index]
                                    };
                                    var addfollowingJson =
                                        JsonEncoder().convert(addfollowing);
                                    http.post(
                                        "http://postea-server.herokuapp.com/followdata",
                                        headers: {
                                          'Content-Type': 'application/json',
                                          HttpHeaders.authorizationHeader:
                                              "Bearer posteaadmin",
                                        },
                                        body: addfollowingJson);
                                  }

                                  setState(() {});
                                })),
                      )
                    ],
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
