import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilitySettings extends StatefulWidget {
  @override
  _AccessibilitySettingsState createState() => _AccessibilitySettingsState();
}

class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  ValueNotifier<bool> accessibilityToggle = new ValueNotifier(false);
  Color accessibilityColor = Colors.redAccent[100].withOpacity(0.5);
  SharedPreferences prefs;

  initializeSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  initializeToggleValue() async {
    await initializeSharedPrefs();
    if (prefs.getInt("accessibility") == 1) {
      accessibilityColor = Colors.greenAccent;
      accessibilityToggle.value = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeToggleValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Security",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          width: screenWidth,
          height: screenHeight,
          margin: EdgeInsets.only(left: 30, right: 15),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(CupertinoIcons.volume_up)),
                    Text("Turn on Text to Speech"),
                    Spacer(),
                    ValueListenableBuilder(
                      valueListenable: accessibilityToggle,
                      builder: (context, value, child) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: 20,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: accessibilityColor),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                  child: InkWell(
                                    onTap: () async {
                                      // theme.addListener(() {
                                      //   if(widget.accessibilityToggle.value ==
                                      // });
                                      await initializeSharedPrefs();
                                      if (accessibilityToggle.value) {
                                        print("HI true");
                                        accessibilityColor =
                                            Colors.redAccent.withOpacity(0.5);
                                        accessibilityToggle.value = false;
                                        prefs.setInt("accessibility", 0);
                                      } else {
                                        print("HI false");
                                        accessibilityColor = Colors.greenAccent;
                                        accessibilityToggle.value = true;
                                        prefs.setInt("accessibility", 1);
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
                      child: Icon(Icons.clear),
                    ),
                    Text("Clear Search History",
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
