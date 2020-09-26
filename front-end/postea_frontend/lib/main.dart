import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_models/timer.dart';
// import 'pages/homepage.dart';
import 'data_models/route_generator.dart';

void main() => runApp(PosTea());

class PosTea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimerCount(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "PosTea app",
        initialRoute: '/profile',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}