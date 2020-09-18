import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_models/timer.dart';
import 'pages/homepage.dart';

import 'pages/wrapper.dart';

void main() => runApp(PosTea());

class PosTea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Adding comments to fix auth-frontend merge
    return MaterialApp(
      title: "PosTea app",
      home: ChangeNotifierProvider(
        create: (context) => TimerCount(), 
        child: HomePage(),
        )
    );
  }
}
