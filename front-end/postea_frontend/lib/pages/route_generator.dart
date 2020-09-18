import 'package:flutter/material.dart';
import 'package:postea_frontend/main.dart';
import 'package:postea_frontend/pages/homepage.dart';
import 'login.dart';
import 'signup.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch(settings.name){
      case '/login': // do login
        return MaterialPageRoute(
          builder: (_) => Login()
        );
      case '/signup': //do signup
        return MaterialPageRoute(
          builder: (_) => SignUp()
        );
      case '/home': return MaterialPageRoute(builder: (_) => HomePage());// do homepage
      case '/profile': // do profile
      default: return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}