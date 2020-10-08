import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';
import 'package:postea_frontend/data_models/process_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  var name = "";
  var bio_data="";
  bool isPrivate = false;
  Map<String, dynamic> profile;

  var _nameController = TextEditingController();
  var _biodataController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  updateProfile() async {

    var sendAnswer = JsonEncoder().convert({"original_username": "dkaneria", "update_privateAcc": isPrivate.toString(), "update_name": name, "update_biodata": bio_data, "update_profilePic": "random"});

    http.Response resp = await http.post(
      "http://postea-server.herokuapp.com/updateprofile?account=dkaneria&name="+name+"&biodata="+bio_data+"&privacy="+isPrivate.toString(),
      headers: {'Content-Type': 'application/json'},
      body: sendAnswer
      );
      print(resp.body);
    if(resp.statusCode == 200)
    print("success");
    else print("Some error");

  }

  getProfile() async {
    http.Response resp  = await http.get("http://postea-server.herokuapp.com/getprofile?username=dkaneria");
    profile = jsonDecode(resp.body);
    setState(() {

      _nameController.text = profile["message"]["name"];
    name = _nameController.text;
    _biodataController.text = profile["message"]["biodata"];
    bio_data = _biodataController.text;
    isPrivate = profile["message"]["privacy"].toString().toLowerCase() == "true";
      
    });
    
    print(profile["message"]["profile_id"]);
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(icon: Icon(Icons.edit, color: Colors.black,), onPressed: () {
            showDialog(context: context,
            barrierDismissible: false,
            barrierColor: barrier,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState){
                  return Dialog(
                  
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Container(
                    height: screenHeight/1.8,
                    width: screenWidth/1.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),),
                    
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                            child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 5, right: 15, left: 15),
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: false,
                                fillColor: Colors.purple[50],
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.deepPurple[900]),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.red[900]),
                                 ),
                              ),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            minLines: 10,
                            maxLines: 10,
                            controller: _biodataController,
                          decoration: InputDecoration(
                            hintText: "About",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: false,
                            fillColor: Colors.purple[50],
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.deepPurple[900]),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.red[900]),
                             ),
                          ),
                        ),
                          ),
                        ListTile(
                          title: Text("Private account"),
                          trailing: Switch(value: isPrivate, onChanged: (value){
                            setState(() {
                              isPrivate = value;
                              print(isPrivate);
                            }); 
                          },
                          activeColor: Colors.red[900],
                          activeTrackColor: bg3,),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
                            child: ButtonTheme(
      
                            shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(100),
                                                    side: BorderSide(color: Colors.redAccent)),
                            minWidth: screenWidth/4,
                            child: RaisedButton(
                              onPressed: () async {

                                bio_data = _biodataController.text;
                                name = _nameController.text;

                                print("name: "+name);
                                print("biodata: "+bio_data);
                                print("privacy: "+ isPrivate.toString());

                                updateProfile();

                              },
                              elevation: 1,
                              color: loginButton,
                              highlightColor: Colors.red[700],
                              child: Text("Submit", style: TextStyle(color: Colors.white),),)
                              ),
                        )
                      ],
                    ),
                  ),

                );

                },
              );
            },
            );
          },)
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Container(
              height: screenHeight /4,
              width: screenWidth,
              color: Colors.transparent,
              // padding: EdgeInsets.only(top: screenHeight / 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                      height: screenWidth/4,
                      width: screenWidth/4,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(side: BorderSide(width: 1, color: Colors.blueGrey))
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage("https://picsum.photos/200"),
                        maxRadius: screenWidth/8,
                      
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                        name,
                        maxFontSize: 29,
                        minFontSize: 27,
                        softWrap: true,
                      ),
                     Padding(padding: EdgeInsets.only(bottom: screenHeight/40)),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                Text("Followers", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("4.5k")
                              ],
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: screenWidth/25)),
                            Container(
                              // height: 20,
                              width: 0.5,
                              color: Colors.blueGrey,
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: screenWidth/25)),
                            Column(
                              children: [
                                Text("Following", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("4.4k")
                              ],
                            )
                          ],
                        ),
                      )
                      ]
                    ),

                      ],
                    ),
                  ),
                  // Profile circle
                  
                  // Center(
                  //   child: Container(
                  //     child: Container(),
                  //     height: screenHeight / 7,
                  //     width: screenHeight / 7,
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //         color: Colors.grey,
                  //         borderRadius: BorderRadius.circular(100)),
                  //   ),
                  // ),
                  SizedBox(
                    height: screenHeight / 25,
                  ),
                  // Profile Name
                  
                  // SizedBox(height: screenHeight / 25),
                  // Follow & Following Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Follower button
                    //   Stack(
                    //     alignment: Alignment.centerRight,
                    //     children: [
                    //       ButtonTheme(
                    //         padding: EdgeInsets.only(right: 40),
                    //         height: 50,
                    //         minWidth: screenWidth / 2.5,
                    //         child: RaisedButton(
                    //           color: profileButtoColor,
                    //           onPressed: () {},
                    //           child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceAround,
                    //               children: [
                    //                 // IconButton(
                    //                 //     icon: Icon(Icons.add), onPressed: () {}),
                    //                 Text("Followers")
                    //               ]),
                    //           elevation: 0,
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(100),
                    //               side: BorderSide(color: Colors.transparent)),
                    //         ),
                    //       ),
                    //       ButtonTheme(
                    //         height: 55,
                    //         minWidth: screenWidth / 7,
                    //         child: RaisedButton(
                    //           color: ffDisplayer,
                    //           onPressed: () {},
                    //           child: Text("4.2k"),
                    //           elevation: 6,
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.only(
                    //                   topLeft: Radius.zero,
                    //                   bottomLeft: Radius.zero,
                    //                   topRight: Radius.circular(100),
                    //                   bottomRight: Radius.circular(100)),
                    //               side: BorderSide(color: Colors.black12)),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    //   Stack(
                    //     alignment: Alignment.centerRight,
                    //     children: [
                    //       ButtonTheme(
                    //         padding: EdgeInsets.only(right: 40),
                    //         height: 50,
                    //         minWidth: screenWidth / 2.6,
                    //         child: RaisedButton(
                    //           color: profileButtoColor,
                    //           onPressed: () {},
                    //           child: Text(
                    //             "Following",
                    //           ),
                    //           elevation: 0,
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(100),
                    //               side: BorderSide(color: Colors.transparent)),
                    //         ),
                    //       ),
                    //       ButtonTheme(
                    //         height: 55,
                    //         minWidth: screenWidth / 7,
                    //         child: RaisedButton(
                    //           color: ffDisplayer,
                    //           onPressed: () {},
                    //           child: Text("6.5k"),
                    //           elevation: 6,
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.only(
                    //                   topLeft: Radius.zero,
                    //                   bottomLeft: Radius.zero,
                    //                   topRight: Radius.circular(100),
                    //                   bottomRight: Radius.circular(100)),
                    //               side: BorderSide(color: Colors.black12)),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: screenHeight / 1.6,
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
                    height: screenHeight / 1.8,
                    color: Colors.transparent,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: screenWidth,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: EdgeInsets.only(left: 12, right: 12),
                            clipBehavior: Clip.antiAlias,
                            elevation: 0,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  height: screenHeight/2,
                                  child: ListView(
                                    
                                    padding: EdgeInsets.all(0),
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      ListTile(
                                  title: Text("Who?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                                  subtitle: Text(bio_data, style: TextStyle(color: Colors.black, fontSize: 17),),
                                  
                                  ),
                                  Padding(padding: EdgeInsets.all(10)),
                                  ListTile(
                                  title: Text("Where?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                                  subtitle: Row(
                                    children: [
                                      Icon(Icons.location_on, size: 18, color: Colors.blueGrey,),
                                      Text("Stockholm, Sweden", style: TextStyle(color: Colors.black, fontSize: 17),)
                                    ],
                                  )
                                  ),

                                    ],
                                    
                                  ),
                                )
                              ],
                            ),
                          )
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
      ),
    );
  }
}
