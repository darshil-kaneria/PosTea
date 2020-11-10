import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FollowingList extends StatefulWidget {

  var profileId;

  FollowingList({this.profileId});
  @override
  _FollowingListState createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  
  List<String> followingList = [];
  Future<http.Response> getFollowingList() async {
    followingList = [];
    http.Response resp = await http.get(
      "http://postea-server.herokuapp.com/followdata?profile_id="+widget.profileId.toString()+"&flag=following_list",
    );

    return resp;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      body: Container(
        margin: EdgeInsets.all(14),
        child: FutureBuilder(
          future: getFollowingList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              print("HERE");
              var temp = jsonDecode(snapshot.data.body);
              for(var i = 0; i < temp.length; i++){
                followingList.add(temp[i]['follower_id'].toString());
              }
              return ListView.builder(
                itemCount: followingList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(followingList[index].toString()),
                  );
                },
              );
            }
            else return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}