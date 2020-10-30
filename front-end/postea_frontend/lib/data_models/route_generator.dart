import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/pages/devpage.dart';
import 'package:postea_frontend/pages/error.dart';
import 'package:postea_frontend/pages/homepage.dart';
import 'package:postea_frontend/pages/login.dart';
import 'package:postea_frontend/pages/onboarding.dart';
import 'package:postea_frontend/pages/profile.dart';
import 'package:postea_frontend/pages/signup.dart';
import 'package:postea_frontend/pages/loggedIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Router {

  static SharedPreferences pref;
  static int profileId;

  // static Future<int> getPref() async {
  //   pref = await SharedPreferences.getInstance();
  //   profileId = pref.getInt('profileID') ?? 0;
  //   print("Logged in to: "+profileId.toString());
  //   return profileId;
  // }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    HomePage args = settings.arguments;
    // Profile pargs = settings.arguments;
    // print(pargs);
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
      case '/home': 
        // SharedPreferences.getInstance().then((SharedPreferences sp) {
        //   profileId = sp.getInt('profileID');
        // });
      return MaterialPageRoute(builder: (_) => HomePage(profileID: args.profileID));// do homepage
      case '/devpage': return MaterialPageRoute(builder: (_) => DevPage());// do DevPage
      case '/error': return MaterialPageRoute(builder: (_) => ErrorPage());// do errorPage
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