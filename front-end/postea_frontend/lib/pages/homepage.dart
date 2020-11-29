import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'dart:math';
import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postea_frontend/colors.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/customWidgets/customNavBar.dart';
import 'package:postea_frontend/customWidgets/postTile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:postea_frontend/data_models/process_topic.dart';
//import 'package:postea_frontend/customWidgets/customAppBar.dart';
import 'package:postea_frontend/data_models/timer.dart';
import 'package:postea_frontend/main.dart';
import 'package:postea_frontend/pages/create_topic.dart';
import 'package:postea_frontend/pages/discoverTopics.dart';
import 'package:postea_frontend/pages/profile.dart';
import 'package:postea_frontend/pages/settingsPage.dart';
import 'package:postea_frontend/pages/trending.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:postea_frontend/customWidgets/topic_pill.dart';
import 'package:http/http.dart' as http;
import 'package:postea_frontend/data_models/process_timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'login.dart';
import 'topic.dart';
import 'settingsPage.dart';
import '../data_models/process_search.dart';
import 'package:linkwell/linkwell.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  int profileID;

  HomePage({@required this.profileID});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // File _postImage;

  var _scrollController = new ScrollController();
  var postTextController = new TextEditingController();
  var postTitleController = new TextEditingController();
  var checkPosScrollController = new ScrollController();
  var topicEditingController = new TextEditingController();
  var searchTextController = new TextEditingController();
  ValueNotifier<String> topicButtonText = ValueNotifier<String>("Topic");
  bool checkBoxVal = false;
  bool checkEnd = false;
  File imgToUpload;
  String base64Image = "";
  ProcessTimeline timeLine;
  ValueNotifier<int> isAnonymous = new ValueNotifier(0);
  ValueNotifier<Color> isAnonColor = new ValueNotifier(Colors.grey);
  ValueNotifier<bool> showNameSuggestions = new ValueNotifier(false);
  var is_private = 0;
  var postID;
  ValueNotifier<int> offset = ValueNotifier<int>(0);
  List<String> topic_id_list = [];
  List<String> post_id_list = [];
  List<dynamic> engagementInfo = [];
  WebSocketChannel webSocketChannel;
  SharedPreferences pref;
  ValueNotifier<bool> showBadge = ValueNotifier<bool>(false);
  ValueNotifier<String> notifString = ValueNotifier<String>("");
  var notifList = [];
  AudioCache _audioCache;
  // var searchResults = [];

  Future getNotifs(Stream stream) async {
    await for (var notif in stream) {
      if (notif != "__ping__" && notif != "HELLO CLIENT") {
        showBadge.value = true;
        _audioCache.play('eventually-590.mp3');
        Map<String, dynamic> notifMap = jsonDecode(notif);
        notifString.value = notif;
        notifList.add(notifMap);
        print("notif is: ");
        print(notifList[0]['senderID']);
      } else {
        webSocketChannel.sink.add("__pong__");
        print("Sent pong");
      }
    }
  }

  getUserData() async {
    http
        .get("http://postea-server.herokuapp.com/getUserInfo?profile_id=" +
            widget.profileID.toString())
        .then((result) {
      var results = jsonDecode(result.body);
      // List<int> post_id_list = results['postIDs'].cast<int>();

      engagementInfo = results['engagementInfo'];

      for (var i = 0; i < results['postIDs'].cast<int>().length; i++) {
        post_id_list.add(results['postIDs'][i].toString());
      }

      for (var i = 0; i < results['topicIDs'].cast<int>().length; i++) {
        topic_id_list.add(results['topicIDs'][i].toString());
      }

      pref.setStringList('postIDList', post_id_list);
      pref.setStringList('topicIDList', topic_id_list);
      pref.setString('engagementInfo', json.encode(engagementInfo));

      // var val = pref.getString('engagementInfo');
      // List<dynamic> engagementInfoJSON = jsonDecode(val);
      // print(engagementInfoJSON[0]);
    });
  }

  ValueNotifier<int> searchNow = ValueNotifier<int>(0);

  _scrollListener() {
    // if (checkPosScrollController.offset <=
    //         checkPosScrollController.position.minScrollExtent &&
    //     !checkPosScrollController.position.outOfRange) {
    //   setState(() {
    //     offset = 0;
    //     print("Timeline refreshed");
    //     timeLine.clearTimeline();
    //   });
    // }

    if (checkPosScrollController.offset >=
            checkPosScrollController.position.maxScrollExtent &&
        !checkPosScrollController.position.outOfRange) {
      print("ISPOST" + timeLine.postRetrieved.toString());
      if (!timeLine.isEnd && timeLine.postRetrieved)
        // setState(() {
        print("SETSTATE CALLED");
      if (timeLine.postList.length != 0) offset.value = offset.value + 10;
      updatePost();
      // });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print("app inactive");
        break;
      case AppLifecycleState.detached:
        print("app detached");
        webSocketChannel.sink.close();
        break;
      case AppLifecycleState.paused:
        print("app paused");
        break;
      case AppLifecycleState.resumed:
        print("app resumed");
        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // checkPosScrollController.dispose();
    // _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print("removed observer");
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    print("added observer");
    print("The profile ID is: " + widget.profileID.toString());
    timeLine = new ProcessTimeline(widget.profileID);
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   var timer = Provider.of<TimerCount>(context, listen: false);
    //   timer.changeVal();
    //  });
    initializeSharedPref();
    initializeWebSocket();
    _audioCache = AudioCache(prefix: "assets/audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
    getUserData();
    checkPosScrollController.addListener(_scrollListener);
    //  setState(() {
    // offset = offset+3;
    updatePost();
    //         });
    super.initState();
  }

  pickImage() async {
    // PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery);
    imgToUpload = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(imgToUpload);
  }

  getFollowingList() async {
    print("hello before taking following data list");
    http.Response resp = await http.get(
      "http://postea-server.herokuapp.com/followdata?profile_id=" +
          widget.profileID.toString() +
          "&flag=following_list",
    );
    print("following list is " + json.decode(resp.body).toString());

    var followingData = json.decode(resp.body);

    print("hello before taking topic list");
    http.Response response = await http.get(
        "http://postea-server.herokuapp.com/getFollowingTopics?profile_id=" +
            widget.profileID.toString());
    print("topic following list is " + json.decode(resp.body).toString());

    var topicFollowData = json.decode(response.body);

    var finalFollowData = [];
    for (var i = 0; i < followingData.length; i++) {
      finalFollowData.add(followingData[i]);
    }

    for (var i = 0; i < topicFollowData.length; i++) {
      finalFollowData.add(topicFollowData[i]);
    }

    print("final follow data is " + finalFollowData.toString());

    return finalFollowData;
  }

  Future uploadImage(File file) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("post").child(postID.toString());
    await storageReference.putFile(file).onComplete;
    print("Uploaded image to Firebase");
  }

  void makePost() async {
    Random random = new Random();
    postID = (random.nextInt(10000000));
    var reqBody = {
      "postTitle": postTitleController.text,
      "msg": postTextController.text,
      "topic": topicEditingController.text,
      "img": base64Image == "" ? "0" : "1",
      "topicID": 21,
      "profileID": widget.profileID,
      "likes": 0,
      "dislikes": 0,
      "comment": 0,
      "anonymous": isAnonymous.value,
      "is_private": is_private,
      "postID": postID
    };
    var reqBodyJson = jsonEncode(reqBody);
    print("sending" + reqBodyJson);
    http
        .post("http://postea-server.herokuapp.com/post",
            headers: {"Content-Type": "application/json"}, body: reqBodyJson)
        .then((value) => print(value.body));
  }

  Future<http.Response> updatePost() async {
    await timeLine.setOffset(offset.value);
    return await timeLine.getPosts();
  }

  Future<http.Response> getSearchResults(String searchString) async {
    ProcessSearch processSearch = new ProcessSearch(searchString: searchString);
    http.Response resp = await processSearch.getSearchResults();
    print(resp.body.toString());
    return resp;
  }

  bool isTopicOwner(int topicID) {
    ProcessTopic processTopic = new ProcessTopic(topic_id: topicID);
    var topicInfo = processTopic.getTopicInfo();
    if (widget.profileID == topicInfo["topic_creator_id"]) {
      return true;
    } else {
      return false;
    }
  }

  initializeSharedPref() async {
    pref = await SharedPreferences.getInstance();
  }

  initializeWebSocket() async {
    webSocketChannel =
        IOWebSocketChannel.connect("ws://postea-server.herokuapp.com");

    print("WEB SOCKET CONNECTION ESTABLISHED!");

    webSocketChannel.sink.add(widget.profileID.toString());

    print("WEB SOCKET: Profile ID " + widget.profileID.toString() + " sent");
    getNotifs(webSocketChannel.stream.asBroadcastStream());
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    isAnonColor.value = Theme.of(context).hintColor;
    PageController pageController = new PageController(initialPage: 0);

    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      children: [
        Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Text(
                      "Vidit Shah",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                  decoration: BoxDecoration(color: Colors.purple[900]),
                ),
                ListTile(
                  title: Text(
                    "Settings",
                    style: TextStyle(color: Theme.of(context).buttonColor),
                  ),
                  leading: Icon(
                    Icons.settings,
                    size: 20,
                    color: Theme.of(context).buttonColor,
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                ),
                ListTile(
                  title: Text("Logout",
                      style: TextStyle(color: Theme.of(context).buttonColor)),
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Theme.of(context).buttonColor,
                  ),
                  onTap: () async {
                    pref.clear().then((value) async {
                      if (value == true) {
                        await FirebaseAuth.instance.signOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomNavBar(
            context,
            onTap: (value) {
              if (value == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Trending(profileId: widget.profileID)));
              } else if (value == 3) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreateTopic(
                              profile_id: widget.profileID,
                            )));
                // MaterialPageRoute(
                //     builder: (_) => Topic(
                //           profileId: widget.profileID,
                //           isOwner: true,
                //           topicId: "21",
                //         )));
              } else if (value == 4) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreateTopic(
                              profile_id: widget.profileID,
                            )));
              } else if (value == 1)
                // Making a post logic
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return WillPopScope(
                        onWillPop: () async {
                          postTitleController.clear();
                          postTextController.clear();
                          return true;
                        },
                        child: Dialog(
                          backgroundColor: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Container(
                            width: screenWidth / 1.1,
                            height: screenHeight / 1.8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 18, right: 18, top: 15),
                                    color: Colors.transparent,
                                    child: TextField(
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Title",
                                      ),
                                      controller: postTitleController,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: SingleChildScrollView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        TextField(
                                          cursorColor: Colors.black,
                                          maxLines: null,
                                          onChanged: (text) {
                                            if (text.endsWith("@")) {
                                              showNameSuggestions.value = true;
                                            } else if (!text.contains("@")) {
                                              showNameSuggestions.value = false;
                                            } else if (text.contains("@") &&
                                                text.lastIndexOf(" ") >
                                                    text.indexOf("@")) {
                                              showNameSuggestions.value = false;
                                            }
                                          },
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Post description",
                                          ),
                                          controller: postTextController,
                                        ),
                                        Container(
                                          child: ValueListenableBuilder(
                                            valueListenable:
                                                showNameSuggestions,
                                            builder: (_, value, __) {
                                              if (value) {
                                                return FutureBuilder(
                                                  future: getFollowingList(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      var followingData =
                                                          snapshot.data;
                                                      return Container(
                                                        width: screenWidth,
                                                        height:
                                                            screenHeight / 2,
                                                        child: ListView.builder(
                                                          itemCount:
                                                              followingData
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              onTap: () {
                                                                String
                                                                    currPostDesc =
                                                                    postTextController
                                                                        .text;

                                                                int indexOfAt =
                                                                    currPostDesc
                                                                        .indexOf(
                                                                            "@");

                                                                if (followingData[
                                                                            index]
                                                                        [
                                                                        'username'] !=
                                                                    null) {
                                                                  if (indexOfAt ==
                                                                      currPostDesc
                                                                              .length -
                                                                          1) {
                                                                    postTextController
                                                                        .text = postTextController
                                                                            .text +
                                                                        followingData[index]
                                                                            [
                                                                            'username'];
                                                                  } else {
                                                                    postTextController.text = postTextController.text.replaceFirst(
                                                                        currPostDesc.substring(
                                                                            indexOfAt +
                                                                                1,
                                                                            currPostDesc
                                                                                .length),
                                                                        followingData[index]
                                                                            [
                                                                            'username']);
                                                                  }
                                                                } else {
                                                                  if (indexOfAt ==
                                                                      currPostDesc
                                                                              .length -
                                                                          1) {
                                                                    postTextController
                                                                        .text = postTextController
                                                                            .text +
                                                                        followingData[index]
                                                                            [
                                                                            'topic_name'];
                                                                  } else {
                                                                    postTextController.text = postTextController.text.replaceFirst(
                                                                        currPostDesc.substring(
                                                                            indexOfAt +
                                                                                1,
                                                                            currPostDesc
                                                                                .length),
                                                                        followingData[index]
                                                                            [
                                                                            'topic_name']);
                                                                  }
                                                                }
                                                              },
                                                              leading:
                                                                  FutureBuilder(
                                                                future: followingData[index]
                                                                            [
                                                                            'profile_id'] ==
                                                                        null
                                                                    ? FirebaseStorageService
                                                                        .getImage(
                                                                        context,
                                                                        followingData[index]['topic_id']
                                                                            .toString(),
                                                                      )
                                                                    : FirebaseStorageService
                                                                        .getImage(
                                                                        context,
                                                                        followingData[index]['profile_id']
                                                                            .toString(),
                                                                      ),
                                                                builder: (context,
                                                                    AsyncSnapshot<
                                                                            dynamic>
                                                                        snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    return CircleAvatar(
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              snapshot.data),
                                                                      maxRadius:
                                                                          screenWidth /
                                                                              25,
                                                                    );
                                                                  } else {
                                                                    return CircleAvatar(
                                                                      maxRadius:
                                                                          screenWidth /
                                                                              25,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              "https://picsum.photos/250?image=18"),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              title: followingData[
                                                                              index]
                                                                          [
                                                                          'username'] ==
                                                                      null
                                                                  ? Text(
                                                                      followingData[
                                                                              index]
                                                                          [
                                                                          'topic_name'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                                  : Text(
                                                                      followingData[
                                                                              index]
                                                                          [
                                                                          'username'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                              subtitle:
                                                                  followingData[index]
                                                                              [
                                                                              'username'] ==
                                                                          null
                                                                      ? Text(
                                                                          "Topic",
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        )
                                                                      : Text(
                                                                          "Profile",
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    } else {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  bgGradEnd),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 13, right: 13),
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                              Icons.image,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                            onPressed: () async {
                                              await pickImage();
                                              // Image image = Image.file(imgToUpload);
                                              if (imgToUpload == null) {
                                                // final imgErrorSnackBar = SnackBar(content: Text('Image upload failed'));
                                                // Scaffold.of(context).showSnackBar(imgErrorSnackBar);
                                              }
                                              base64Image = base64Encode(
                                                  imgToUpload
                                                      .readAsBytesSync());
                                            }),
                                        IconButton(
                                            icon: Icon(
                                              Icons.attachment,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                            onPressed: () {}),
                                        ValueListenableBuilder(
                                          valueListenable: isAnonymous,
                                          builder: (context, value, child) {
                                            return IconButton(
                                                icon: Icon(
                                                  Icons.fingerprint,
                                                  color: isAnonColor.value,
                                                ),
                                                onPressed: () {
                                                  if (isAnonymous.value == 0) {
                                                    isAnonymous.value = 1;
                                                    isAnonColor.value =
                                                        Colors.deepOrange[100];
                                                  } else if (isAnonymous
                                                          .value ==
                                                      1) {
                                                    isAnonymous.value = 0;
                                                    isAnonColor.value =
                                                        Theme.of(context)
                                                            .hintColor;
                                                  }
                                                  // setState(() {});
                                                  print(isAnonymous.value);
                                                });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            CupertinoIcons.eye,
                                            color: Theme.of(context).hintColor,
                                            size: 30,
                                          ),
                                          onPressed: () {},
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 15),
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: screenHeight / 22,
                                              width: screenWidth / 4.5,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: ButtonTheme(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            17)),
                                                child: FlatButton(
                                                  onPressed: () => {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (context) {
                                                        return WillPopScope(
                                                            child: Dialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Container(
                                                                width:
                                                                    screenWidth /
                                                                        1.1,
                                                                height:
                                                                    screenHeight /
                                                                        7,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    TextField(
                                                                      controller:
                                                                          topicEditingController,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            InputBorder.none,
                                                                        hintText:
                                                                            "Enter a topic",
                                                                      ),
                                                                    ),
                                                                    ButtonTheme(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child: RaisedButton(
                                                                          child: Text("Choose Topic"),
                                                                          onPressed: () {
                                                                            // setState(() {
                                                                            topicButtonText.value =
                                                                                topicEditingController.text;
                                                                            print(topicEditingController.text);
                                                                            // });
                                                                            Navigator.of(context, rootNavigator: true).pop();
                                                                          }),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            onWillPop:
                                                                () async {
                                                              topicEditingController
                                                                  .clear();
                                                              return true;
                                                            });
                                                      },
                                                    )
                                                  },
                                                  child: Text(
                                                    topicButtonText.value,
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () async {
                                      // Making a post request
                                      makePost();
                                      if (base64Image != "") {
                                        await uploadImage(imgToUpload);
                                      }

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 13),
                                      alignment: Alignment.center,
                                      child: Text("Post"),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.5))),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                );
            },
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            // leading: Icon(Icons.menu),
            elevation: 0,
            iconTheme: IconThemeData(
              color: Theme.of(context).buttonColor,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: 20,
                ),
                onPressed: () {
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.bounceInOut);
                },
              ),
              ValueListenableBuilder(
                valueListenable: showBadge,
                builder: (context, value, child) {
                  print("VALUE IS: " + value.toString());
                  return Badge(
                    showBadge: value
                        ? (notifString.value == "HELLO CLIENT" ? false : true)
                        : false,
                    animationType: BadgeAnimationType.fade,
                    badgeColor: Colors.deepOrange[200],
                    position: BadgePosition.topEnd(top: 10, end: 10),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications,
                        size: 20,
                      ),
                      onPressed: () {
                        showBadge.value = false;
                        pageController.jumpToPage(2);
                      },
                    ),
                  );
                },
              ),
              // StreamBuilder(
              //     stream: webSocketChannel.stream.asBroadcastStream(),
              //     builder: (context, snapshot) {
              //       if(snapshot.hasData){
              //         print(snapshot.data);
              //         if(snapshot.data == "__ping__"){
              //           webSocketChannel.sink.add("__pong__");
              //         }
              //       }
              //       ValueNotifier<bool> showBadge = ValueNotifier<bool>(snapshot.hasData);
              //         return ValueListenableBuilder(
              //           valueListenable: showBadge,
              //           builder: (context, value, child) => Badge(
              //             showBadge: showBadge.value ? (snapshot.data == "__ping__" || snapshot.data == "HELLO CLIENT" ? false : true) : false,
              //             badgeColor: Colors.deepOrange[200],
              //             position: BadgePosition.topEnd(top: 10, end: 10),
              //             animationType: BadgeAnimationType.fade,
              //             child: IconButton(
              //                 icon: Icon(
              //                   Icons.notifications,
              //                   size: 20,
              //                 ),
              //                 onPressed: () {
              //                   showBadge.value = false;
              //                   pageController.jumpToPage(2);
              //                 }),
              //           ),
              //         );
              //     }),
              IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Profile(
                              profileId: widget.profileID,
                              isOwner: true,
                            )));
                  }),
            ],
          ),
          backgroundColor: Theme.of(context).canvasColor,
          body: Column(
            children: [
              // StreamBuilder(
              //   stream: webSocketChannel.stream,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       if (snapshot.data == "__ping__") {
              //         webSocketChannel.sink.add("__pong__");
              //         return Text("Received PING. SENT PONG");
              //       } else {
              //         return Text(snapshot.data);
              //       }
              //     } else {
              //       return Text("Awaiting message");
              //     }
              //   },
              // ),
              Container(
                height: screenHeight / 15,
                width: screenWidth,
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    TopicPill(
                      topicId: 2,
                      col1: Theme.of(context).primaryColorLight,
                      col2: Theme.of(context).primaryColorDark,
                      height: screenHeight / 15,
                      width: screenWidth / 4,
                      profileId: widget.profileID,
                      isOwner: true,
                    ),
                    TopicPill(
                      topicId: 26894,
                      col1: Theme.of(context).primaryColorLight,
                      col2: Theme.of(context).primaryColorDark,
                      height: screenHeight / 15,
                      width: screenWidth / 4,
                      profileId: widget.profileID,
                      isOwner: true,
                    ),
                    TopicPill(
                      topicId: 51561,
                      col1: Theme.of(context).primaryColorLight,
                      col2: Theme.of(context).primaryColorDark,
                      height: screenHeight / 15,
                      width: screenWidth / 4,
                      profileId: widget.profileID,
                      isOwner: true,
                    ),
                    TopicPill(
                      topicId: 99841,
                      col1: Theme.of(context).primaryColorLight,
                      col2: Theme.of(context).primaryColorDark,
                      height: screenHeight / 15,
                      width: screenWidth / 4,
                      profileId: widget.profileID,
                      isOwner: true,
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: timeLine.isLoaded,
                  builder: (context, value, child) {
                    print("ISLOADED: " + timeLine.isLoaded.toString());
                    // return FutureBuilder(
                    // future: updatePost(),
                    // builder: (BuildContext context,
                    // AsyncSnapshot<http.Response> snapshot) {
                    // if (snapshot.hasData) {
                    return RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: checkPosScrollController,
                          itemCount: timeLine.postList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == timeLine.postList.length &&
                                timeLine.postList.length != 1) {
                              // print("SIZE IS: "+snapshot.data.contentLength.toString());
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Center(
                                    child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(bgGradEnd),
                                )),
                              );
                            }
                            print("LIKES ARE: " +
                                timeLine.postList.elementAt(index).post_likes);
                            return PostTile(
                                timeLine.postList.elementAt(index).post_id,
                                timeLine.postList.elementAt(index).profile_id,
                                timeLine.postList
                                    .elementAt(index)
                                    .post_description,
                                timeLine.postList.elementAt(index).topic_id,
                                timeLine.postList.elementAt(index).post_img,
                                timeLine.postList
                                    .elementAt(index)
                                    .creation_date,
                                timeLine.postList.elementAt(index).post_likes,
                                timeLine.postList
                                    .elementAt(index)
                                    .post_dislikes,
                                timeLine.postList
                                    .elementAt(index)
                                    .post_comments,
                                timeLine.postList.elementAt(index).post_title,
                                timeLine.postList.elementAt(index).post_name,
                                widget.profileID.toString(),
                                0,
                                timeLine.postList
                                    .elementAt(index)
                                    .is_sensitive);
                          }),
                    );
                    // } else
                    //   return Center(
                    //       child: CircularProgressIndicator(
                    //     valueColor: AlwaysStoppedAnimation(bgGradEnd),
                    //   ));
                    // else return null;
                    // });
                  },
                  // child: ,
                ),
              )
            ],

            // child: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Text("This timer is changing"),
            //     Consumer<TimerCount>(builder: (context, data, child){
            //       return AutoSizeText(
            //         data.getTime().toString(),
            //         style: TextStyle(fontSize: 15),
            //         );
            //     })
            //   ],

            // )
          ),
        ),
        SafeArea(
          child: Container(
            color: Theme.of(context).canvasColor,
            child: Container(
              margin: EdgeInsets.only(top: screenHeight / 25),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Material(
                        type: MaterialType.card,
                        clipBehavior: Clip.antiAlias,
                        color: Theme.of(context).bottomAppBarColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                ),
                                onPressed: () {
                                  pageController.jumpToPage(0);

                                  searchTextController.clear();
                                }),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 7,
                                right: 18,
                              ),
                              child: Container(
                                width: screenWidth / 1.7,
                                height: screenHeight / 15,
                                child: TextField(
                                  controller: searchTextController,
                                  decoration: InputDecoration(
                                      hintText: "Search",
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  searchNow.value += 1;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Container(
                      // height: screenHeight / 1.2,
                      margin: EdgeInsets.only(top: 10),
                      child: ValueListenableBuilder(
                          valueListenable: searchNow,
                          builder: (_, value, __) {
                            if (value > 0) {
                              return FutureBuilder(
                                  future: getSearchResults(
                                      searchTextController.text),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<http.Response> snapshot) {
                                    if (snapshot.hasData) {
                                      List searchResults =
                                          jsonDecode(snapshot.data.body);

                                      print(searchResults);
                                      print("len of search results is " +
                                          searchResults.length.toString());
                                      return Material(
                                        color: Theme.of(context).canvasColor,
                                        child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: searchResults.length,
                                          itemBuilder: (context, index) {
                                            print(
                                                "index is " + index.toString());
                                            print("dict at index is " +
                                                searchResults[index]
                                                    .toString());
                                            if (searchResults[index] != null) {
                                              if (searchResults[index]
                                                      ['type'] ==
                                                  "profile") {
                                                return ListTile(
                                                  onTap: () {
                                                    if (searchResults[index]
                                                            ['profile_id'] ==
                                                        widget.profileID) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Profile(
                                                            profileId:
                                                                searchResults[
                                                                        index][
                                                                    'profile_id'],
                                                            isOwner: true,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Profile(
                                                            profileId:
                                                                searchResults[
                                                                        index][
                                                                    'profile_id'],
                                                            isOwner: false,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  leading: FutureBuilder(
                                                    future: FirebaseStorageService
                                                        .getImage(
                                                            context,
                                                            searchResults[index]
                                                                    [
                                                                    'profile_id']
                                                                .toString()),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  snapshot
                                                                      .data),
                                                        );
                                                      } else {
                                                        return CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .buttonColor,
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    loginButtonEnd));
                                                      }
                                                    },
                                                  ),
                                                  title: Text(
                                                    searchResults[index]['name']
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline1,
                                                  ),
                                                  subtitle: Text(
                                                      searchResults[index]
                                                              ['type']
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3),
                                                );
                                              } else {
                                                return ListTile(
                                                  onTap: () {
                                                    var topicIDList =
                                                        pref.getStringList(
                                                            'topicIDList');
                                                    if (topicIDList.contains(
                                                        searchResults[index]
                                                                ['topic_id']
                                                            .toString())) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Topic(
                                                            profileId: widget
                                                                .profileID,
                                                            topicId:
                                                                searchResults[
                                                                        index][
                                                                    'topic_id'],
                                                            isOwner: true,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Topic(
                                                            profileId: widget
                                                                .profileID,
                                                            topicId:
                                                                searchResults[
                                                                        index][
                                                                    'topic_id'],
                                                            isOwner: false,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  leading: FutureBuilder(
                                                    future: FirebaseStorageService
                                                        .getTopicImage(
                                                            context,
                                                            searchResults[index]
                                                                    ['topic_id']
                                                                .toString()),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  snapshot
                                                                      .data),
                                                        );
                                                      } else {
                                                        return CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .buttonColor,
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    loginButtonEnd));
                                                      }
                                                    },
                                                  ),
                                                  title: Text(
                                                      searchResults[index]
                                                              ['topic_name']
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline1),
                                                  subtitle: Text(
                                                      searchResults[index]
                                                              ['type']
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3),
                                                );
                                              }
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      );
                                    } else {
                                      if (searchTextController
                                          .text.isNotEmpty) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                bgGradEnd),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }
                                  });
                            } else {
                              return Container();
                            }
                          }),
                      // ValueListenableBuilder(
                      //   valueListenable: searchNow,
                      //   builder: (_, value, __) {
                      //     return Container(
                      //       child: ListView.builder(
                      //           itemCount: searchResults.length,
                      //           itemBuilder: (context, index) {
                      //             return ListTile(
                      //               leading: Image(
                      //                   image: NetworkImage(
                      //                       "https://picsum.photos/250?image=18")),
                      //               title: searchResults[index]['name'],
                      //               subtitle: searchResults[index]['type'],
                      //             );
                      //           }),
                      //     );
                      //   },
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: screenWidth,
          height: screenHeight,
          color: Theme.of(context).canvasColor,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                child: Material(
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            pageController.jumpToPage(0);
                          }),
                      Text(
                        "Notifications",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Icon(Icons.notifications)
                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth,
                height: screenHeight / 1.129,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: screenWidth / 1.4,
                                height: screenHeight / 1.1,
                                child: notifList.length == 0
                                    ? Center(
                                        child: Container(
                                        margin: EdgeInsets.only(bottom: 100),
                                        child: Text(
                                            "You do not have any notifications!"),
                                      ))
                                    : ListView.builder(
                                        itemCount: notifList.length,
                                        itemBuilder: (context, index) {
                                          print(notifList[index]);
                                          return ListTile(
                                            leading: FutureBuilder(
                                              future: FirebaseStorageService
                                                  .getImage(
                                                      context,
                                                      notifList[index]
                                                          ['senderID']),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<dynamic>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            snapshot.data),
                                                  );
                                                } else {
                                                  return CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            bgGradEnd),
                                                  );
                                                }
                                              },
                                            ),
                                            title: Text(
                                                notifList[index]['senderName']),
                                            subtitle: Text(
                                                notifList[index]['engagement']),
                                          );
                                          // return FutureBuilder(
                                          //   future: FirebaseStorageService.getImage(
                                          //       context,
                                          //       notifList[index]['senderID']),
                                          //   builder: (context, snapshot) {
                                          //     if (snapshot.hasData) {
                                          //       return ListTile(
                                          //         leading: CircleAvatar(
                                          //           backgroundImage:
                                          //               NetworkImage(snapshot.data),
                                          //         ),
                                          //         title: Text(
                                          //             notifList[index]['senderName']),
                                          //         subtitle: Text(
                                          //             notifList[index]['engagement']),
                                          //       );
                                          //     } else {
                                          //       return Center(
                                          //         child: CircularProgressIndicator(
                                          //           valueColor:
                                          //               AlwaysStoppedAnimation(
                                          //                   bgGradEnd),
                                          //         ),
                                          //       );
                                          //     }
                                          //   },
                                          // );
                                        },
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleRefresh() {
    Completer<Null> completer = new Completer<Null>();
    // setState(() {
    offset.value = 0;
    timeLine.setOffset(0);
    print("Timeline refreshed");
    timeLine.clearTimeline();
    // });
    completer.complete();
    return completer.future;
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

  static Future<dynamic> getTopicImage(
      BuildContext context, String image) async {
    return await FirebaseStorage.instance
        .ref()
        .child("topic")
        .child(image)
        .getDownloadURL();
  }
}
