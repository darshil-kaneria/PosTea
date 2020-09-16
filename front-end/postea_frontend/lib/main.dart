import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_models/timer.dart';
import 'pages/homepage.dart';

void main() => runApp(PosTea());

class PosTea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PosTea",
      home: ChangeNotifierProvider(
        create: (context) => TimerCount(), 
        child: HomePage(),
        )
    );
  }
}