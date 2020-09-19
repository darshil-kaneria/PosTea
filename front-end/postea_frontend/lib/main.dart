import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data_models/timer.dart';
// import 'pages/homepage.dart';
import 'pages/route_generator.dart';

import 'pages/wrapper.dart';
import './pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PosTea());
}

class PosTea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimerCount(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "PosTea app",
        initialRoute: '/login',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
