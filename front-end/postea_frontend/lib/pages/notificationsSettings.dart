import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:postea_frontend/data_models/process_theme.dart';

class NotificationsSettings extends StatefulWidget {
  @override
  _NotificationsSettingsState createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  ValueNotifier<bool> notificationsToggle = new ValueNotifier(false);
  Color notificationsColor = Colors.redAccent[100].withOpacity(0.5);
  SharedPreferences prefs;

  initializeSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  initializeToggleValue() async {
    await initializeSharedPrefs();
    if (prefs.getInt("accessibility") == 1) {
      notificationsColor = Colors.greenAccent;
      notificationsToggle.value = true;
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
          "Notifications",
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
                      Icons.remove,
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                  Text("Opt-out of all emails from PosTea",
                      style: Theme.of(context).textTheme.headline5),
                  Spacer(),
                  ValueListenableBuilder(
                    valueListenable: notificationsToggle,
                    builder: (context, value, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: 20,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: notificationsColor),
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                                child: InkWell(
                                  onTap: () async {
                                    // theme.addListener(() {
                                    //   if(widget.notificationsToggle.value ==
                                    // });
                                    await initializeSharedPrefs();
                                    if (notificationsToggle.value) {
                                      print("HI true");
                                      notificationsColor =
                                          Colors.redAccent.withOpacity(0.5);
                                      notificationsToggle.value = false;
                                    } else {
                                      print("HI false");
                                      notificationsColor = Colors.greenAccent;
                                      notificationsToggle.value = true;
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
          ],
        ),
      ),
    );
  }
}
