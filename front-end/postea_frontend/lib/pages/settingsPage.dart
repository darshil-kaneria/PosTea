import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/data_models/process_theme.dart';
import 'package:postea_frontend/pages/accessibilitySettings.dart';
import 'package:postea_frontend/pages/notificationsSettings.dart';
import 'package:provider/provider.dart';
import './login.dart';
import '../data_models/delete_user.dart';
import 'package:postea_frontend/pages/securitySettings.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  ValueNotifier<bool> themeToggle = new ValueNotifier(false);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool toggleColor = false;
  Color toggle = Colors.redAccent[100].withOpacity(0.5);
  bool darkModeToggle = false;
  bool profileMode = false;
  Color darkModeToggleColor = Colors.redAccent[100].withOpacity(0.5);
  final theme = ProcessTheme();
  var emailController = new TextEditingController();
  var passwordController = new TextEditingController();

  isPrivate() async {
    prefs = await SharedPreferences.getInstance();
    var queryString;

    // print("Not here");
    queryString = "http://postea-server.herokuapp.com/profile/" +
        prefs.getInt('profileID').toString();

    http.Response resp = await http.get(
      queryString,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer posteaadmin",
      },
    );
    var profile = jsonDecode(resp.body);
    profileMode =
        profile["message"]["privacy"].toString().toLowerCase() == "true";
  }

  // ValueNotifier<bool> themeToggle = new ValueNotifier(false);

  SharedPreferences prefs;

  initializeSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  updateProfileMode(int isPrivate) async {
    var url = "http://postea-server.herokuapp.com/profileMode";

    var sendAnswer = JsonEncoder().convert({
      "profileID": prefs.getInt('profileID'),
      "isPrivate": isPrivate,
    });

    http.Response resp = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: "Bearer posteaadmin",
        },
        body: sendAnswer);
    print(resp.body);
    if (resp.statusCode == 200)
      print("success");
    else
      print("Some error");
  }

  // isPrivate() async {
  //   prefs = await SharedPreferences.getInstance();
  //   var queryString;

  //   // print("Not here");
  //   queryString = "http://postea-server.herokuapp.com/profile/" +
  //       prefs.getInt('profileID').toString();

  //   http.Response resp = await http.get(queryString);
  //   var profile = jsonDecode(resp.body);
  //   return profile["message"]["privacy"].toString().toLowerCase() == "true";
  // }

  darkModetoggleButton() {
    if (widget.themeToggle.value) {
      darkModeToggleColor = Colors.redAccent.withOpacity(0.5);
      widget.themeToggle.value = false;
    } else {
      darkModeToggleColor = Colors.greenAccent;
      widget.themeToggle.value = true;
    }
    // setState(() {
    //   if (darkModeToggle) {
    //     darkModeToggle = false;
    //     // darkModeToggleColor = Colors.redAccent[100].withOpacity(0.5);
    //     darkModeToggleColor = Colors.greenAccent[100];
    //   } else {
    //     darkModeToggle = true;
    //     darkModeToggleColor = Colors.redAccent[100].withOpacity(0.5);
    //     // darkModeToggleColor = Colors.greenAccent[100];
    //   }
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    theme.addListener(() {
      print("Something changed: " + theme.themeData.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    isPrivate();
    ValueNotifier<bool> profileToggle = new ValueNotifier(profileMode);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).buttonColor),
        title: Text("Settings", style: Theme.of(context).textTheme.headline4),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          width: screenWidth,
          height: screenHeight,
          margin: EdgeInsets.only(top: 20, left: 30, right: 15),
          child: ListView(
            children: [
              Text(
                "Profile",
                style: Theme.of(context).textTheme.headline4,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        CupertinoIcons.profile_circled,
                        color: Theme.of(context).buttonColor,
                      ),
                    ),
                    Text(
                      "Private Account?",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Spacer(),
                    ValueListenableBuilder(
                      valueListenable: profileToggle,
                      builder: (context, value, child) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: 20,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: toggle),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                  child: InkWell(
                                    onTap: () {
                                      if (profileToggle.value) {
                                        updateProfileMode(0);
                                        toggle =
                                            Colors.redAccent.withOpacity(0.5);
                                        profileToggle.value = false;
                                      } else {
                                        updateProfileMode(1);
                                        toggle = Colors.greenAccent;
                                        profileToggle.value = true;
                                      }
                                      // toggleButton();
                                    },
                                    child: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 200),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return ScaleTransition(
                                          child: child,
                                          scale: animation,
                                        );
                                      },
                                      child: value
                                          ? Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 15,
                                              key: UniqueKey(),
                                            )
                                          : Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.red,
                                              size: 15,
                                              key: UniqueKey(),
                                            ),
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                  top: 3,
                                  left: value ? 30 : 0,
                                  right: value ? 0 : 30),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "General",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.wb_sunny,
                        color: Theme.of(context).buttonColor,
                      ),
                    ),
                    Text(
                      "Dark Theme",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Spacer(),
                    ValueListenableBuilder(
                      valueListenable: widget.themeToggle,
                      builder: (context, value, child) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: 20,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: darkModeToggleColor),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                  child: InkWell(
                                    onTap: () {
                                      // theme.addListener(() {
                                      //   if(widget.themeToggle.value ==
                                      // });
                                      if (widget.themeToggle.value) {
                                        print("HI true");
                                        darkModeToggleColor =
                                            Colors.redAccent.withOpacity(0.5);
                                        widget.themeToggle.value = false;
                                        Provider.of<ProcessTheme>(context,
                                                listen: false)
                                            .changeTheme();
                                      } else {
                                        print("HI false");
                                        darkModeToggleColor =
                                            Colors.greenAccent;
                                        widget.themeToggle.value = true;
                                        Provider.of<ProcessTheme>(context,
                                                listen: false)
                                            .changeTheme();
                                      }
                                    },
                                    child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 200),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return ScaleTransition(
                                            child: child,
                                            scale: animation,
                                          );
                                        },
                                        child: value
                                            ? Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 15,
                                                key: UniqueKey(),
                                              )
                                            : Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.red,
                                                size: 15,
                                                key: UniqueKey(),
                                              )),
                                  ),
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                  top: 3,
                                  left: value ? 30 : 0,
                                  right: value ? 0 : 30)
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccessibilitySettings()));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.accessibility,
                            color: Theme.of(context).buttonColor),
                      ),
                      Text("Accessibility",
                          style: Theme.of(context).textTheme.headline5),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          color: Theme.of(context).buttonColor)
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecuritySettings()));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.security,
                            color: Theme.of(context).buttonColor),
                      ),
                      Text("Security",
                          style: Theme.of(context).textTheme.headline5),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          color: Theme.of(context).buttonColor)
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationsSettings()));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.notifications,
                            color: Theme.of(context).buttonColor),
                      ),
                      Text("Notifications",
                          style: Theme.of(context).textTheme.headline5),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          color: Theme.of(context).buttonColor)
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.info,
                          color: Theme.of(context).buttonColor),
                    ),
                    Text("About", style: Theme.of(context).textTheme.headline5),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios,
                        color: Theme.of(context).buttonColor)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.help,
                          color: Theme.of(context).buttonColor),
                    ),
                    Text("Help", style: Theme.of(context).textTheme.headline5),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios,
                        color: Theme.of(context).buttonColor)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 75),
                child: ButtonTheme(
                  minWidth: screenWidth / 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: RaisedButton(
                    elevation: 2,
                    clipBehavior: Clip.antiAlias,
                    onPressed: () {},
                    color: Colors.redAccent,
                    child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return WillPopScope(
                                    onWillPop: () async {
                                      emailController.clear();
                                      passwordController.clear();
                                      return true;
                                    },
                                    child: Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      child: Container(
                                        width: screenWidth / 3.5,
                                        height: screenHeight / 2.5,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                "We need to make sure it is indeed you!",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15,
                                                  top: 10,
                                                  right: 25,
                                                  bottom: 10),
                                              child: TextField(
                                                controller: emailController,
                                                textAlign: TextAlign.left,
                                                decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(),
                                                    border: InputBorder.none,
                                                    hintText:
                                                        "Enter your email"),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15,
                                                  top: 10,
                                                  right: 25,
                                                  bottom: 10),
                                              child: TextField(
                                                controller: passwordController,
                                                textAlign: TextAlign.left,
                                                autocorrect: false,
                                                enableSuggestions: false,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(),
                                                    border: InputBorder.none,
                                                    hintText:
                                                        "Enter your password"),
                                              ),
                                            ),
                                            ButtonTheme(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: RaisedButton(
                                                  child: Text("Delete Account"),
                                                  onPressed: () async {
                                                    String email =
                                                        emailController.text;
                                                    String password =
                                                        passwordController.text;

                                                    User user = FirebaseAuth
                                                        .instance.currentUser;
                                                    DeleteUser deleteUser =
                                                        new DeleteUser(
                                                            user: user,
                                                            email: email,
                                                            password: password);

                                                    var result =
                                                        await deleteUser
                                                            .deleteUserData();

                                                    print("result is " +
                                                        result.toString());
                                                    if (result == "success") {
                                                      await initializeSharedPref();
                                                      String username =
                                                          prefs.getString(
                                                              "username");
                                                      final request =
                                                          http.Request(
                                                        "DELETE",
                                                        Uri.parse(
                                                            "http://postea-server.herokuapp.com/user"),
                                                      );
                                                      request.headers.addAll(
                                                        {
                                                          'Content-Type':
                                                              'application/json',
                                                          HttpHeaders
                                                                  .authorizationHeader:
                                                              "Bearer posteaadmin",
                                                        },
                                                      );
                                                      request.body = jsonEncode(
                                                        {
                                                          "account_username":
                                                              username,
                                                        },
                                                      );
                                                      request.send();
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Login()));
                                                    }
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Text("Delete Account")),
                  ),
                ),
              ),
            ],
          )
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text("Profile",
          //         style: TextStyle(
          //             color: Colors.black,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 30))
          //   ],
          // ),
          ),
    );
  }
}
