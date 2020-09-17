import 'dart:async';
import 'package:postea_frontend/colors.dart';
import 'package:flutter/material.dart';
//import 'package:postea_frontend/customWidgets/customAppBar.dart';
import 'package:postea_frontend/data_models/timer.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      var timer = Provider.of<TimerCount>(context, listen: false);
      timer.changeVal();
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications), onPressed: null),
          IconButton(icon: Icon(Icons.account_circle), onPressed: null)
        ],
      ),
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("This timer is changing"),
            Consumer<TimerCount>(builder: (context, data, child){
              return AutoSizeText(
                data.getTime().toString(),
                style: TextStyle(fontSize: 15),
                );
            })
          ],

        )
      ),
    );
  }
}