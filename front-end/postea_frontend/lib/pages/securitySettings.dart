import 'package:flutter/material.dart';

class SecuritySettings extends StatefulWidget {
  @override
  _SecuritySettingsState createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {
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
                      child: Icon(Icons.lock),
                    ),
                    Text("Change Password", style: TextStyle(fontSize: 20)),
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
