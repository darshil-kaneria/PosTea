import 'dart:async';

import 'package:flutter/material.dart';
import 'package:postea_frontend/data_models/timer.dart';
import 'package:provider/provider.dart';

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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("This timer is changing"),
            Consumer<TimerCount>(builder: (context, data, child){
              return Text(data.getTime().toString());
            })
          ],

        )
      ),
    );
  }
}