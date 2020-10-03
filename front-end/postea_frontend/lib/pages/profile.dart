import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';
import 'package:postea_frontend/data_models/process_profile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  var profileName = "Carl Grey";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProcessProfile.getProfileName();


  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            height: screenHeight / 2,
            width: screenWidth,
            color: Colors.transparent,
            padding: EdgeInsets.only(top: screenHeight / 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Profile circle
                Center(
                  child: Container(
                    child: Container(),
                    height: screenHeight / 7,
                    width: screenHeight / 7,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 25,
                ),
                // Profile Name
                Text(
                  profileName,
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: screenHeight / 25),
                // Follow & Following Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Follower button
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ButtonTheme(
                          padding: EdgeInsets.only(right: 65),
                          height: 50,
                          minWidth: screenWidth / 2.5,
                          child: RaisedButton(
                            color: profileButtoColor,
                            onPressed: () {},
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.add), onPressed: () {}),
                                  Text("Followers")
                                ]),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(color: Colors.transparent)),
                          ),
                        ),
                        ButtonTheme(
                          height: 55,
                          minWidth: screenWidth / 7,
                          child: RaisedButton(
                            color: ffDisplayer,
                            onPressed: () {},
                            child: Text("4.2k"),
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.zero,
                                    bottomLeft: Radius.zero,
                                    topRight: Radius.circular(100),
                                    bottomRight: Radius.circular(100)),
                                side: BorderSide(color: Colors.black12)),
                          ),
                        )
                      ],
                    ),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ButtonTheme(
                          padding: EdgeInsets.only(right: 40),
                          height: 50,
                          minWidth: screenWidth / 2.6,
                          child: RaisedButton(
                            color: profileButtoColor,
                            onPressed: () {},
                            child: Text(
                              "Following",
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(color: Colors.transparent)),
                          ),
                        ),
                        ButtonTheme(
                          height: 55,
                          minWidth: screenWidth / 7,
                          child: RaisedButton(
                            color: ffDisplayer,
                            onPressed: () {},
                            child: Text("6.5k"),
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.zero,
                                    bottomLeft: Radius.zero,
                                    topRight: Radius.circular(100),
                                    bottomRight: Radius.circular(100)),
                                side: BorderSide(color: Colors.black12)),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            height: screenHeight / 2,
            width: screenWidth,
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ButtonTheme(
                      child: FlatButton(
                        onPressed: () {},
                        child: Text(
                          "About",
                          style: TextStyle(fontFamily: "Open Sans"),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      child: FlatButton(
                        onPressed: () {},
                        child: Text("Posts"),
                      ),
                    ),
                    ButtonTheme(
                      child: FlatButton(
                        onPressed: () {},
                        child: Text("Topic"),
                      ),
                    )
                  ],
                ), // Row for tab buttons About - Posts - Topic
                Container(
                  height: screenHeight / 2.3,
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: screenWidth,
                        child: Text("About"),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: screenWidth,
                        child: Text("Posts"),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: screenWidth,
                        child: Text("Topics"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // Container(
          //   height: screenHeight/3,
          //   width: screenWidth,
          //   color: Colors.yellowAccent,
          // ),
        ]),
      ),
    );
  }
}
