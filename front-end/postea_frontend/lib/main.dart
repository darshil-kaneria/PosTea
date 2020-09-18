import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_models/timer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/homepage.dart';

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
    // Adding comments to fix auth-frontend merge
    return MaterialApp(
        title: "PosTea app",
        home: ChangeNotifierProvider(
          create: (context) => TimerCount(),
          child: Login(),
        ));
  }
}
