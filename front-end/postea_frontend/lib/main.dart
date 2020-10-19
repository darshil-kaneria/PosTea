import 'package:flutter/material.dart';
import 'package:postea_frontend/pages/loggedIn.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data_models/timer.dart';
// import 'pages/homepage.dart';
import 'data_models/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/wrapper.dart';
import './pages/login.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PosTea());
}

class PosTea extends StatefulWidget {
  @override
  _PosTeaState createState() => _PosTeaState();
}

class _PosTeaState extends State<PosTea> {

  var firstScreen = '/login';

void checkUserLoggedIn() {
    User user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        firstScreen = '/home';
      });
    }
    else {
      setState(() {
        firstScreen = '/login';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return ChangeNotifierProvider(
      create: (context) => TimerCount(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "PosTea app",
        initialRoute: firstScreen,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
