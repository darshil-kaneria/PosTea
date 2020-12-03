import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:postea_frontend/data_models/process_theme.dart';

class AccessibilitySettings extends StatefulWidget {
  @override
  _AccessibilitySettingsState createState() => _AccessibilitySettingsState();
}

class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  ValueNotifier<bool> accessibilityToggle = new ValueNotifier(false);
  ValueNotifier<String> fontSize = new ValueNotifier("normal");
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
        iconTheme: IconThemeData(color: Theme.of(context).buttonColor),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Accessibility",
          style: Theme.of(context).textTheme.headline4,
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
                    child: Icon(
                      CupertinoIcons.volume_up,
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                  Text("Turn on Text to Speech",
                      style: Theme.of(context).textTheme.headline5),
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
                    child: Text(
                      "A",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).buttonColor),
                    ),
                  ),
                  Text("Change Font Size",
                      style: Theme.of(context).textTheme.headline5),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      onTap: () {
                        fontSize.value = "large";
                        Provider.of<ProcessTheme>(context, listen: false)
                            .font_size(1.3);
                      },
                      child: ValueListenableBuilder(
                        valueListenable: fontSize,
                        builder: (context, value, child) {
                          return Text(
                            "A",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: value == "large"
                                    ? Colors.blue
                                    : Theme.of(context).buttonColor),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      onTap: () {
                        fontSize.value = "normal";
                        Provider.of<ProcessTheme>(context, listen: false)
                            .font_size(1);
                      },
                      child: ValueListenableBuilder(
                        valueListenable: fontSize,
                        builder: (context, value, child) {
                          return Text(
                            "A",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: value == "normal"
                                    ? Colors.blue
                                    : Theme.of(context).buttonColor),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      onTap: () {
                        fontSize.value = "small";
                        Provider.of<ProcessTheme>(context, listen: false)
                            .font_size(0.7);
                      },
                      child: ValueListenableBuilder(
                        valueListenable: fontSize,
                        builder: (context, value, child) {
                          return Text(
                            "A",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: value == "small"
                                    ? Colors.blue
                                    : Theme.of(context).buttonColor),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
