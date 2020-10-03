import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/pages/error.dart';
import 'package:postea_frontend/pages/homepage.dart';
import 'package:postea_frontend/pages/login.dart';
import 'package:postea_frontend/pages/profile.dart';
import 'package:postea_frontend/pages/signup.dart';
import 'package:postea_frontend/pages/loggedIn.dart';

class Router {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch(settings.name){
      case '/login': // do login
        return MaterialPageRoute(
          builder: (_) => Login(),
          
        );
      case '/signup': //do signup
        return PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) {
            return SignUp();
            },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(begin: Offset(1,0), end: Offset(0,0)).animate(CurvedAnimation(parent: animation, curve: Curves.decelerate)), child: child,));
          },
        );
      case '/home': return MaterialPageRoute(builder: (_) => HomePage());// do homepage
      case '/error': return MaterialPageRoute(builder: (_) => ErrorPage());// do homepage
      case '/profile': // do profile
        return PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) {
            return Profile();
            },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(begin: Offset(0,-1), end: Offset(0,0)).animate(CurvedAnimation(parent: animation, curve: Curves.decelerate)), child: child,));
          },
        );
      default: return null;
      //default: return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}