import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/pages/securitySettings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool toggleColor = false;
  Color toggle = Colors.redAccent[100].withOpacity(0.5);
  bool darkModeToggle = false;
  Color darkModeToggleColor = Colors.redAccent[100].withOpacity(0.5);

  toggleButton() {
    setState(() {
      if (toggleColor) {
        toggleColor = false;
        toggle = Colors.redAccent[100].withOpacity(0.5);
      } else {
        toggleColor = true;
        toggle = Colors.greenAccent[100];
      }
    });
  }

  darkModetoggleButton() {
    setState(() {
      if (darkModeToggle) {
        darkModeToggle = false;
        // darkModeToggleColor = Colors.redAccent[100].withOpacity(0.5);
        darkModeToggleColor = Colors.greenAccent[100];
      } else {
        darkModeToggle = true;
        darkModeToggleColor = Colors.redAccent[100].withOpacity(0.5);
        // darkModeToggleColor = Colors.greenAccent[100];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Settings", style: TextStyle(color: Colors.black)),
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
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(CupertinoIcons.profile_circled),
                    ),
                    Text(
                      "Private Account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      height: 20,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: toggle),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                              child: InkWell(
                                onTap: toggleButton,
                                child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 1000),
                                    transitionBuilder: (Widget child,
                                        Animation<double> animation) {
                                      return ScaleTransition(
                                        child: child,
                                        scale: animation,
                                      );
                                    },
                                    child: toggleColor
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
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.easeIn,
                              top: 3,
                              left: toggleColor ? 30 : 0,
                              right: toggleColor ? 0 : 30)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "General",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.wb_sunny),
                    ),
                    Text(
                      "Dark Theme",
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      height: 20,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: darkModeToggleColor),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                              child: InkWell(
                                onTap: darkModetoggleButton(),
                                child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 1000),
                                    transitionBuilder: (Widget child,
                                        Animation<double> animation) {
                                      return ScaleTransition(
                                        child: child,
                                        scale: animation,
                                      );
                                    },
                                    child: darkModeToggle
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
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.easeIn,
                              top: 3,
                              left: darkModeToggle ? 30 : 0,
                              right: darkModeToggle ? 0 : 30)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.accessibility),
                    ),
                    Text("Accessibility", style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
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
                            builder: (context) => SecuritySettings()));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.security),
                      ),
                      Text("Security", style: TextStyle(fontSize: 20)),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios)
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
                      child: Icon(Icons.notifications),
                    ),
                    Text("Notifications", style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.info),
                    ),
                    Text("About", style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.help),
                    ),
                    Text("Help", style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
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
                    child: Text("Delete Account"),
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
