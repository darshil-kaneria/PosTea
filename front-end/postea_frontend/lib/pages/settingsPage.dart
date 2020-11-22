import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './login.dart';
import '../data_models/delete_user.dart';
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

  var emailController = new TextEditingController();
  var passwordController = new TextEditingController();

  ValueNotifier<bool> profileToggle = new ValueNotifier(false);
  ValueNotifier<bool> themeToggle = new ValueNotifier(false);

  toggleButton() {
    if (profileToggle.value) {
      toggle = Colors.redAccent.withOpacity(0.5);
      profileToggle.value = false;
    } else {
      toggle = Colors.greenAccent;
      profileToggle.value = true;
    }
  }

  darkModetoggleButton() {
    if (themeToggle.value) {
      darkModeToggleColor = Colors.redAccent.withOpacity(0.5);
      profileToggle.value = false;
    } else {
      darkModeToggleColor = Colors.greenAccent;
      themeToggle.value = true;
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
                                      toggleButton();
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
                    ValueListenableBuilder(
                      valueListenable: themeToggle,
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
                                      if (themeToggle.value) {
                                        darkModeToggleColor =
                                            Colors.redAccent.withOpacity(0.5);
                                        themeToggle.value = false;
                                      } else {
                                        darkModeToggleColor =
                                            Colors.greenAccent;
                                        themeToggle.value = true;
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
